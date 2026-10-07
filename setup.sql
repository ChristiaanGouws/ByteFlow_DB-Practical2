USE student_4332981;

-- 1. GAMER TABLE
CREATE TABLE `Gamer` (
  `Gamer_ID` int PRIMARY KEY AUTO_INCREMENT,
  `Username` varchar(255) NOT NULL,
  `Email` varchar(255) UNIQUE,
  `Date_of_Birth` date,
  `Age` int
);

-- 2. GAMER_PHONE TABLE (Weak entity resolving a multivalued attribute)
CREATE TABLE `Gamer_Phone` (
  `Phone_ID` int PRIMARY KEY AUTO_INCREMENT,
  `Gamer_ID` int,
  `Phone_Number` varchar(20),
  FOREIGN KEY (`Gamer_ID`) REFERENCES `Gamer` (`Gamer_ID`) ON DELETE CASCADE
);

-- 3. STAFF TABLE
CREATE TABLE `Staff` (
  `Staff_ID` int PRIMARY KEY AUTO_INCREMENT,
  `Name` varchar(255)
);

-- 4. GAMING_STATION TABLE
CREATE TABLE `Gaming_Station` (
  `Station_ID` int PRIMARY KEY AUTO_INCREMENT,
  `Tier` ENUM ('Standard', 'VIP_Pro') NOT NULL,
  `Hourly_Rate` decimal(7,2) NOT NULL
);

-- 5. GAMING_SESSION TABLE (Bridge entity)
CREATE TABLE `Gaming_Session` (
  `Session_ID` int PRIMARY KEY AUTO_INCREMENT,
  `Gamer_ID` int,
  `Station_ID` int,
  `Staff_ID` int,
  `Start_Time` datetime,
  `End_Time` datetime,
  `Duration_Hours` decimal(5,2),
  FOREIGN KEY (`Gamer_ID`) REFERENCES `Gamer` (`Gamer_ID`),
  FOREIGN KEY (`Station_ID`) REFERENCES `Gaming_Station` (`Station_ID`),
  FOREIGN KEY (`Staff_ID`) REFERENCES `Staff` (`Staff_ID`)
);

-- 6. INVOICE TABLE (Session_ID made UNIQUE to enforce 1:1 business rule)
CREATE TABLE `Invoice` (
  `Invoice_ID` int PRIMARY KEY AUTO_INCREMENT,
  `Session_ID` int UNIQUE, 
  `Total_Amount` decimal(7,2),
  `Payment_Status` varchar(50),
  FOREIGN KEY (`Session_ID`) REFERENCES `Gaming_Session` (`Session_ID`)
);

-- DATA INSERTION
INSERT INTO Gamer (Username, Email, Date_of_Birth, Age) VALUES 
('ShadowKnight', 'shadow@gmail.com', '2001-05-14', 25),
('PixelQueen', 'queen@yahoo.com', '1998-11-22', 27),
('NoobSlayer', 'slayer@gaming.net', '2005-02-10', 21),
('CyberNinja', 'ninja@gmail.com', '1995-07-30', 31);

INSERT INTO Gamer_Phone (Gamer_ID, Phone_Number) VALUES 
(1, '555-0101'), (1, '555-0102'), (2, '555-0201'), (4, '555-0401');

INSERT INTO Staff (Name) VALUES 
('Marcus Johnson'), ('Sarah Lee');

INSERT INTO Gaming_Station (Tier, Hourly_Rate) VALUES 
('Standard', 15.00), ('Standard', 15.00), ('VIP_Pro', 30.00), ('VIP_Pro', 30.00);

INSERT INTO Gaming_Session (Gamer_ID, Station_ID, Staff_ID, Start_Time, End_Time, Duration_Hours) VALUES 
(1, 3, 1, '2026-10-10 14:00:00', '2026-10-10 16:30:00', 2.5),
(2, 1, 2, '2026-10-10 15:00:00', '2026-10-10 16:00:00', 1.0),
(3, 4, 1, '2026-10-11 10:00:00', '2026-10-11 14:00:00', 4.0),
(1, 1, 2, '2026-10-12 18:00:00', '2026-10-12 20:00:00', 2.0);

INSERT INTO Invoice (Session_ID, Total_Amount, Payment_Status) VALUES 
(1, 75.00, 'Paid'), (2, 15.00, 'Paid'), (3, 120.00, 'Pending'), (4, 30.00, 'Paid');