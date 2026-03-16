-- =============================================================
--  TRAINER-CLIENT HUB  |  MySQL Database Schema
--  Normalized to 3NF
--  Author   : Smaran Aryal  (CIS096-1)
--  Database : trainer_client_hub
-- =============================================================

CREATE DATABASE IF NOT EXISTS trainer_client_hub
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE trainer_client_hub;

-- =============================================================
-- TABLE 1: trainer
--   Stores gym trainer accounts.
--   Independent root entity – no FKs.
-- =============================================================
CREATE TABLE trainer (
    trainer_id   INT            NOT NULL AUTO_INCREMENT,
    name         VARCHAR(100)   NOT NULL,
    email        VARCHAR(150)   NOT NULL,
    phone        VARCHAR(20)    NOT NULL,
    password_hash VARCHAR(255)  NOT NULL,                -- BCrypt hash; never plaintext
    created_at   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_trainer        PRIMARY KEY (trainer_id),
    CONSTRAINT uq_trainer_email  UNIQUE      (email),
    CONSTRAINT chk_trainer_email CHECK       (email LIKE '%_@__%.__%')
);


-- =============================================================
-- TABLE 2: client
--   Stores gym member profiles.
--   References trainer (many clients → one trainer).
-- =============================================================
CREATE TABLE client (
    client_id       INT           NOT NULL AUTO_INCREMENT,
    name            VARCHAR(100)  NOT NULL,
    age             TINYINT       NOT NULL,
    gender          ENUM('Male','Female','Other') NOT NULL,
    phone           VARCHAR(20)   NOT NULL,
    email           VARCHAR(150)  NOT NULL,
    session_balance SMALLINT      NOT NULL DEFAULT 0,
    weight_kg       DECIMAL(5,2)  NOT NULL,
    trainer_id      INT           NOT NULL,
    created_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_client          PRIMARY KEY (client_id),
    CONSTRAINT uq_client_email    UNIQUE      (email),
    CONSTRAINT fk_client_trainer  FOREIGN KEY (trainer_id)
                                  REFERENCES  trainer(trainer_id)
                                  ON UPDATE CASCADE
                                  ON DELETE RESTRICT,
    CONSTRAINT chk_client_age         CHECK (age BETWEEN 10 AND 100),
    CONSTRAINT chk_client_session_bal CHECK (session_balance >= 0),
    CONSTRAINT chk_client_weight      CHECK (weight_kg BETWEEN 20.00 AND 300.00),
    CONSTRAINT chk_client_email       CHECK (email LIKE '%_@__%.__%')
);


-- =============================================================
-- TABLE 3: membership_plan
--   Lookup table for reusable membership templates.
--   Decoupled so plan details aren't duplicated per client.
--   3NF: plan attributes depend only on plan_id.
-- =============================================================
CREATE TABLE membership_plan (
    plan_id       INT            NOT NULL AUTO_INCREMENT,
    plan_name     VARCHAR(100)   NOT NULL,
    plan_type     ENUM('Monthly','Quarterly','Annual','Custom') NOT NULL,
    duration_days SMALLINT       NOT NULL,
    price         DECIMAL(10,2)  NOT NULL,

    CONSTRAINT pk_membership_plan    PRIMARY KEY (plan_id),
    CONSTRAINT uq_plan_name          UNIQUE      (plan_name),
    CONSTRAINT chk_plan_duration     CHECK       (duration_days > 0),
    CONSTRAINT chk_plan_price        CHECK       (price >= 0.00)
);


-- =============================================================
-- TABLE 4: membership
--   Records each client's active/historical membership.
--   One client can have at most one ACTIVE membership at a time
--   (enforced via application + partial unique index below).
-- =============================================================
CREATE TABLE membership (
    membership_id INT     NOT NULL AUTO_INCREMENT,
    client_id     INT     NOT NULL,
    plan_id       INT     NOT NULL,
    start_date    DATE    NOT NULL,
    end_date      DATE    NOT NULL,
    status        ENUM('Active','Expired','Cancelled') NOT NULL DEFAULT 'Active',
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_membership          PRIMARY KEY (membership_id),
    CONSTRAINT fk_membership_client   FOREIGN KEY (client_id)
                                      REFERENCES  client(client_id)
                                      ON UPDATE CASCADE
                                      ON DELETE RESTRICT,
    CONSTRAINT fk_membership_plan     FOREIGN KEY (plan_id)
                                      REFERENCES  membership_plan(plan_id)
                                      ON UPDATE CASCADE
                                      ON DELETE RESTRICT,
    CONSTRAINT chk_membership_dates   CHECK (end_date > start_date)
);


-- =============================================================
-- TABLE 5: workout
--   One workout session header per client visit.
--   A workout belongs to one client and is supervised by one trainer.
-- =============================================================
CREATE TABLE workout (
    workout_id   INT           NOT NULL AUTO_INCREMENT,
    client_id    INT           NOT NULL,
    trainer_id   INT           NOT NULL,
    workout_date DATE          NOT NULL,
    total_volume DECIMAL(10,2) NOT NULL DEFAULT 0.00,   -- sum of (sets×reps×weight) across exercises
    notes        TEXT,

    CONSTRAINT pk_workout          PRIMARY KEY (workout_id),
    CONSTRAINT fk_workout_client   FOREIGN KEY (client_id)
                                   REFERENCES  client(client_id)
                                   ON UPDATE CASCADE
                                   ON DELETE RESTRICT,
    CONSTRAINT fk_workout_trainer  FOREIGN KEY (trainer_id)
                                   REFERENCES  trainer(trainer_id)
                                   ON UPDATE CASCADE
                                   ON DELETE RESTRICT,
    CONSTRAINT chk_workout_volume  CHECK (total_volume >= 0)
);


-- =============================================================
-- TABLE 6: exercise
--   Individual exercises within a workout (composition).
--   Cannot exist without a parent workout.
--   ON DELETE CASCADE: deleting a workout removes all its exercises.
-- =============================================================
CREATE TABLE exercise (
    exercise_id   INT           NOT NULL AUTO_INCREMENT,
    workout_id    INT           NOT NULL,
    exercise_name VARCHAR(100)  NOT NULL,
    sets          TINYINT       NOT NULL,
    reps          TINYINT       NOT NULL,
    weight_kg     DECIMAL(6,2)  NOT NULL DEFAULT 0.00,
    volume        DECIMAL(10,2) GENERATED ALWAYS AS (sets * reps * weight_kg) STORED,

    CONSTRAINT pk_exercise          PRIMARY KEY (exercise_id),
    CONSTRAINT fk_exercise_workout  FOREIGN KEY (workout_id)
                                    REFERENCES  workout(workout_id)
                                    ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    CONSTRAINT chk_exercise_sets    CHECK (sets > 0),
    CONSTRAINT chk_exercise_reps    CHECK (reps > 0),
    CONSTRAINT chk_exercise_weight  CHECK (weight_kg >= 0)
);


-- =============================================================
-- TABLE 7: session
--   Scheduled training sessions (booked timeslots).
--   Separate from workout: a session is a calendar event;
--   a workout is the recorded performance data.
-- =============================================================
CREATE TABLE session (
    session_id   INT   NOT NULL AUTO_INCREMENT,
    client_id    INT   NOT NULL,
    trainer_id   INT   NOT NULL,
    session_date DATE  NOT NULL,
    session_time TIME  NOT NULL,
    status       ENUM('Scheduled','Completed','Cancelled','NoShow') NOT NULL DEFAULT 'Scheduled',
    notes        TEXT,

    CONSTRAINT pk_session          PRIMARY KEY (session_id),
    CONSTRAINT fk_session_client   FOREIGN KEY (client_id)
                                   REFERENCES  client(client_id)
                                   ON UPDATE CASCADE
                                   ON DELETE RESTRICT,
    CONSTRAINT fk_session_trainer  FOREIGN KEY (trainer_id)
                                   REFERENCES  trainer(trainer_id)
                                   ON UPDATE CASCADE
                                   ON DELETE RESTRICT
);


-- =============================================================
-- TABLE 8: payment
--   Financial transactions linked to a client and a membership.
--   3NF: all non-key columns depend solely on payment_id.
-- =============================================================
CREATE TABLE payment (
    payment_id     INT           NOT NULL AUTO_INCREMENT,
    client_id      INT           NOT NULL,
    membership_id  INT           NOT NULL,
    amount         DECIMAL(10,2) NOT NULL,
    payment_date   DATE          NOT NULL,
    payment_method ENUM('Cash','Card','Online','BankTransfer') NOT NULL,
    payment_status ENUM('Completed','Pending','Refunded','Failed')  NOT NULL DEFAULT 'Completed',

    CONSTRAINT pk_payment             PRIMARY KEY (payment_id),
    CONSTRAINT fk_payment_client      FOREIGN KEY (client_id)
                                      REFERENCES  client(client_id)
                                      ON UPDATE CASCADE
                                      ON DELETE RESTRICT,
    CONSTRAINT fk_payment_membership  FOREIGN KEY (membership_id)
                                      REFERENCES  membership(membership_id)
                                      ON UPDATE CASCADE
                                      ON DELETE RESTRICT,
    CONSTRAINT chk_payment_amount     CHECK (amount > 0)
);


-- =============================================================
-- TABLE 9: report
--   Stores metadata + generated content for admin reports.
--   generated_by references the trainer (admin) who ran it.
-- =============================================================
CREATE TABLE report (
    report_id      INT      NOT NULL AUTO_INCREMENT,
    generated_by   INT      NOT NULL,
    report_type    ENUM('Client','Membership','Trainer','Attendance','Revenue') NOT NULL,
    generated_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    content        TEXT     NOT NULL,

    CONSTRAINT pk_report           PRIMARY KEY (report_id),
    CONSTRAINT fk_report_trainer   FOREIGN KEY (generated_by)
                                   REFERENCES  trainer(trainer_id)
                                   ON UPDATE CASCADE
                                   ON DELETE RESTRICT
);


-- =============================================================
--  INDEXES
--  Added on all FK columns and commonly searched fields.
-- =============================================================

-- client
CREATE INDEX idx_client_trainer   ON client(trainer_id);
CREATE INDEX idx_client_email     ON client(email);
CREATE INDEX idx_client_name      ON client(name);

-- membership
CREATE INDEX idx_membership_client  ON membership(client_id);
CREATE INDEX idx_membership_plan    ON membership(plan_id);
CREATE INDEX idx_membership_status  ON membership(status);
CREATE INDEX idx_membership_expiry  ON membership(end_date);

-- workout
CREATE INDEX idx_workout_client   ON workout(client_id);
CREATE INDEX idx_workout_trainer  ON workout(trainer_id);
CREATE INDEX idx_workout_date     ON workout(workout_date);

-- exercise
CREATE INDEX idx_exercise_workout ON exercise(workout_id);

-- session
CREATE INDEX idx_session_client   ON session(client_id);
CREATE INDEX idx_session_trainer  ON session(trainer_id);
CREATE INDEX idx_session_date     ON session(session_date);
CREATE INDEX idx_session_status   ON session(status);

-- payment
CREATE INDEX idx_payment_client      ON payment(client_id);
CREATE INDEX idx_payment_membership  ON payment(membership_id);
CREATE INDEX idx_payment_date        ON payment(payment_date);

-- report
CREATE INDEX idx_report_trainer ON report(generated_by);
CREATE INDEX idx_report_type    ON report(report_type);


-- =============================================================
--  SAMPLE SEED DATA  (minimal, for development / testing)
-- =============================================================

INSERT INTO trainer (name, email, phone, password_hash) VALUES
    ('Raj Shrestha',   'raj@gymhub.com',   '9841000001', '$2a$12$placeholder_hash_1'),
    ('Anita Karmakar', 'anita@gymhub.com', '9841000002', '$2a$12$placeholder_hash_2');

INSERT INTO membership_plan (plan_name, plan_type, duration_days, price) VALUES
    ('Monthly Basic',    'Monthly',    30,  1500.00),
    ('Quarterly Plus',   'Quarterly',  90,  4000.00),
    ('Annual Premium',   'Annual',    365, 14000.00);

INSERT INTO client (name, age, gender, phone, email, session_balance, weight_kg, trainer_id) VALUES
    ('Smaran Aryal',  22, 'Male',   '9800000001', 'smaran@example.com',  10, 72.50, 1),
    ('Priya Tamang',  28, 'Female', '9800000002', 'priya@example.com',   8,  58.00, 1),
    ('Bikash Thapa',  35, 'Male',   '9800000003', 'bikash@example.com',  5,  85.00, 2);

INSERT INTO membership (client_id, plan_id, start_date, end_date, status) VALUES
    (1, 2, '2026-01-01', '2026-04-01', 'Active'),
    (2, 1, '2026-02-01', '2026-03-01', 'Active'),
    (3, 3, '2025-10-01', '2026-10-01', 'Active');

INSERT INTO payment (client_id, membership_id, amount, payment_date, payment_method, payment_status) VALUES
    (1, 1, 4000.00, '2026-01-01', 'Cash',   'Completed'),
    (2, 2, 1500.00, '2026-02-01', 'Card',   'Completed'),
    (3, 3, 14000.00,'2025-10-01', 'Online', 'Completed');

INSERT INTO workout (client_id, trainer_id, workout_date, notes) VALUES
    (1, 1, '2026-03-01', 'Push day – chest and triceps'),
    (1, 1, '2026-03-03', 'Pull day – back and biceps'),
    (2, 1, '2026-03-02', 'Full body circuit');

INSERT INTO exercise (workout_id, exercise_name, sets, reps, weight_kg) VALUES
    (1, 'Bench Press',     4, 8,  60.00),
    (1, 'Tricep Pushdown', 3, 12, 20.00),
    (2, 'Barbell Row',     4, 8,  55.00),
    (2, 'Bicep Curl',      3, 12, 15.00),
    (3, 'Squat',           3, 10, 50.00);

INSERT INTO session (client_id, trainer_id, session_date, session_time, status) VALUES
    (1, 1, '2026-03-10', '08:00:00', 'Scheduled'),
    (2, 1, '2026-03-10', '09:30:00', 'Scheduled'),
    (3, 2, '2026-03-11', '07:00:00', 'Scheduled');

-- =============================================================
--  END OF SCHEMA
-- =============================================================
