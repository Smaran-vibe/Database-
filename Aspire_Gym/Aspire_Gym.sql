CREATE DATABASE  AspireGym;
USE AspireGym;

CREATE TABLE MembershipPlan (
    PlanID INT PRIMARY KEY,
    PlanName VARCHAR(50),
    DurationMonths INT,
    Price DECIMAL(8,2)
);

CREATE TABLE Member (
    MemberID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender VARCHAR(10),
    DateOfBirth DATE,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(150),
    JoinDate DATE,
    PlanID INT,
    FOREIGN KEY (PlanID) REFERENCES MembershipPlan(PlanID)
);

CREATE TABLE Trainer (
    TrainerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Phone VARCHAR(15),
    Specialization VARCHAR(100)
);

CREATE TABLE Class (
    ClassID INT PRIMARY KEY,
    ClassName VARCHAR(50),
    ScheduleDate DATE,
    ScheduleTime TIME,
    Capacity INT,
    TrainerID INT,
    FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID)
);

CREATE TABLE ClassBooking (
    BookingID INT PRIMARY KEY,
    BookingDate DATE,
    MemberID INT,
    ClassID INT,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID)
);

CREATE TABLE TrainingSession (
    SessionID INT PRIMARY KEY,
    SessionDate DATE,
    SessionTime TIME,
    MemberID INT,
    TrainerID INT,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID)
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    PaymentDate DATE,
    Amount DECIMAL(8,2),
    PaymentMethod VARCHAR(30),
    MemberID INT,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
);

CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY,
    EquipmentName VARCHAR(100),
    PurchaseDate DATE,
    Status VARCHAR(20)
);

CREATE TABLE Maintenance (
    MaintenanceID INT PRIMARY KEY,
    MaintenanceDate DATE,
    Description VARCHAR(200),
    EquipmentID INT,
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
);

INSERT INTO MembershipPlan (PlanID, PlanName, DurationMonths, Price) VALUES
(1,'Basic Plan',1,30.00),
(2,'Standard Plan',3,80.00),
(3,'Premium Plan',6,150.00);

INSERT INTO Trainer (TrainerID, FirstName, LastName, Phone, Specialization) VALUES
(1,'Smaran','Aryal','9800001111','Strength Training'),
(2,'Saimon','Shrestha','9800002222','Yoga'),
(3,'Wilson','Aryal','9800003333','Cardio Fitness');

INSERT INTO Member (MemberID, FirstName, LastName, Gender, DateOfBirth, Phone, Email, Address, JoinDate, PlanID) VALUES
(101,'Samrat','Lamsal','Male','1995-04-10','9801111111','Ratsam@email.com','Kathmandu','2025-01-10',1),
(102,'Biraj','Aryal','Female','1998-07-15','9802222222','brown@email.com','Pokhara','2025-02-12',2),
(103,'Swornima','Shrestha','Male','1992-03-20','9803333333','nima@email.com','Lalitpur','2025-03-01',3);

INSERT INTO Class (ClassID, ClassName, ScheduleDate, ScheduleTime, Capacity, TrainerID) VALUES
(1,'Yoga Class','2025-06-01','09:00:00',20,2),
(2,'Cardio Blast','2025-06-02','10:00:00',15,3),
(3,'Strength Training','2025-06-03','11:00:00',10,1);

INSERT INTO ClassBooking (BookingID, BookingDate, MemberID, ClassID) VALUES
(1,'2025-05-25',101,1),
(2,'2025-05-26',102,2),
(3,'2025-05-27',103,3);

INSERT INTO TrainingSession (SessionID, SessionDate, SessionTime, MemberID, TrainerID) VALUES
(1,'2025-06-01','08:00:00',101,1),
(2,'2025-06-02','08:30:00',102,2),
(3,'2025-06-03','09:00:00',103,3);

INSERT INTO Payment (PaymentID, PaymentDate, Amount, PaymentMethod, MemberID) VALUES
(1,'2025-01-10',30.00,'Card',101),
(2,'2025-02-12',80.00,'Cash',102),
(3,'2025-03-01',150.00,'Online',103);

INSERT INTO Equipment (EquipmentID, EquipmentName, PurchaseDate, Status) VALUES
(1,'Treadmill','2023-05-10','Available'),
(2,'Bench Press','2022-03-15','Available'),
(3,'Exercise Bike','2024-01-20','Maintenance');

INSERT INTO Maintenance (MaintenanceID, MaintenanceDate, Description, EquipmentID) VALUES
(1,'2025-04-10','Routine Maintenance',3),
(2,'2025-04-15','Belt Replacement',1),
(3,'2025-04-20','Lubrication Service',2);


SELECT * 
FROM Member;

SELECT FirstName, LastName, Specialization
FROM Trainer;

SELECT Class.ClassName, Trainer.FirstName, Trainer.LastName
FROM Class
JOIN Trainer 
ON Class.TrainerID = Trainer.TrainerID;

SELECT Member.FirstName, Member.LastName, Class.ClassName
FROM ClassBooking
JOIN Member ON ClassBooking.MemberID = Member.MemberID
JOIN Class ON ClassBooking.ClassID = Class.ClassID;

SELECT Member.FirstName, Member.LastName, Payment.Amount, Payment.PaymentDate
FROM Payment
JOIN Member 
ON Payment.MemberID = Member.MemberID;

SELECT Member.FirstName, Trainer.FirstName AS Trainer, 
TrainingSession.SessionDate, TrainingSession.SessionTime
FROM TrainingSession
JOIN Member ON TrainingSession.MemberID = Member.MemberID
JOIN Trainer ON TrainingSession.TrainerID = Trainer.TrainerID;

SELECT Equipment.EquipmentName, Maintenance.MaintenanceDate, Maintenance.Description
FROM Maintenance
JOIN Equipment 
ON Maintenance.EquipmentID = Equipment.EquipmentID;

SELECT COUNT(*) AS TotalMembers
FROM Member;

SELECT 
Trainer.TrainerID,
Trainer.FirstName,
Trainer.LastName,
COUNT(Class.ClassID) AS TotalClasses
FROM Trainer
LEFT JOIN Class 
ON Trainer.TrainerID = Class.TrainerID
GROUP BY Trainer.TrainerID, Trainer.FirstName, Trainer.LastName;

SELECT 
SUM(Amount) AS TotalRevenue
FROM Payment;

SELECT 
Class.ClassName,
COUNT(ClassBooking.MemberID) AS TotalParticipants
FROM Class
LEFT JOIN ClassBooking 
ON Class.ClassID = ClassBooking.ClassID
GROUP BY Class.ClassName;

SELECT 
Member.FirstName AS MemberName,
Member.LastName,
Class.ClassName,
Trainer.FirstName AS TrainerName,
Class.ScheduleDate,
Class.ScheduleTime
FROM ClassBooking
JOIN Member 
ON ClassBooking.MemberID = Member.MemberID
JOIN Class 
ON ClassBooking.ClassID = Class.ClassID
JOIN Trainer 
ON Class.TrainerID = Trainer.TrainerID;


SELECT 
Member.FirstName AS MemberName,
Trainer.FirstName AS TrainerName,
TrainingSession.SessionDate,
TrainingSession.SessionTime
FROM TrainingSession
JOIN Member 
ON TrainingSession.MemberID = Member.MemberID
JOIN Trainer 
ON TrainingSession.TrainerID = Trainer.TrainerID
ORDER BY TrainingSession.SessionDate;

SELECT 
MembershipPlan.PlanName,
COUNT(Member.MemberID) AS TotalMembers,
SUM(Payment.Amount) AS TotalRevenue
FROM MembershipPlan
JOIN Member 
ON MembershipPlan.PlanID = Member.PlanID
JOIN Payment 
ON Member.MemberID = Payment.MemberID
GROUP BY MembershipPlan.PlanName
HAVING SUM(Payment.Amount) > 0;
