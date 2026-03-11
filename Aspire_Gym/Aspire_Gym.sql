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
