CREATE TABLE `Gamer` (
  `Gamer_ID` int PRIMARY KEY,
  `Username` varchar(255) NOT NULL,
  `Email` varchar(255) UNIQUE
);

CREATE TABLE `Staff` (
  `Staff_ID` int PRIMARY KEY,
  `Name` varchar(255)
);

CREATE TABLE `Gaming_Station` (
  `Station_ID` int PRIMARY KEY,
  `Tier` ENUM ('Standard', 'VIP_Pro') NOT NULL,
  `Hourly_Rate` decimal
);

CREATE TABLE `Gaming_Session` (
  `Session_ID` int PRIMARY KEY,
  `Gamer_ID` int,
  `Station_ID` int,
  `Staff_ID` int,
  `Start_Time` datetime,
  `End_Time` datetime
);

CREATE TABLE `Invoice` (
  `Invoice_ID` int,
  `Session_ID` int,
  `Total_Amount` decimal,
  `Payment_Status` varchar(255),
  PRIMARY KEY (`Invoice_ID`, `Session_ID`)
);

ALTER TABLE `Gaming_Session` ADD FOREIGN KEY (`Gamer_ID`) REFERENCES `Gamer` (`Gamer_ID`);

ALTER TABLE `Gaming_Session` ADD FOREIGN KEY (`Station_ID`) REFERENCES `Gaming_Station` (`Station_ID`);

ALTER TABLE `Gaming_Session` ADD FOREIGN KEY (`Staff_ID`) REFERENCES `Staff` (`Staff_ID`);

ALTER TABLE `Invoice` ADD FOREIGN KEY (`Session_ID`) REFERENCES `Gaming_Session` (`Session_ID`);
