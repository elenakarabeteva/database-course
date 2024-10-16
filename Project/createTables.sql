-- СКГТ
-- Елена Карабетева

CREATE TABLE Stops(
	ID INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY, 
	stopName VARCHAR(70) NOT NULL UNIQUE,
	latitude DECIMAL(9, 6),
	longitude DECIMAL(9, 6)
);

CREATE TABLE Line(
	-- M - метро
	-- A - автобус
	-- TB - тролейбус
	-- T - трамвай
	lineNumber VARCHAR(6) NOT NULL PRIMARY KEY,
	startStop INT NOT NULL,
	lastStop INT NOT NULL,
	CONSTRAINT FK_LINE_STOP_START FOREIGN KEY (startStop) REFERENCES Stops(ID),
	CONSTRAINT FK_LINE_STOP_END FOREIGN KEY (lastStop) REFERENCES Stops(ID),
	CHECK (
        (UPPER(lineNumber) LIKE 'M[0-9]%' OR UPPER(lineNumber) LIKE 'A[0-9]%'
		OR UPPER(lineNumber) LIKE 'TB[0-9]%' OR UPPER(lineNumber) LIKE 'T[0-9]%')
		AND UPPER(lineNumber) NOT LIKE '__%[A-Z]%')
);

CREATE TABLE Vehicle(
	registrationNumber VARCHAR(20) NOT NULL PRIMARY KEY,
	line VARCHAR(6) NOT NULL,
	stop INT,
    CONSTRAINT FK_VEHICLE_LINE FOREIGN KEY (line) REFERENCES Line(lineNumber) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT FK_VEHICLE_STOP FOREIGN KEY (stop) REFERENCES Stops(ID)
);

CREATE TABLE Schedule(
	line VARCHAR(6) NOT NULL REFERENCES Line(lineNumber),
	stop INT NOT NULL REFERENCES Stops(ID),
	inWeekday INT CHECK (inWeekday IN (0, 1)),
	arrivalTime TIME,
	PRIMARY KEY(line, stop)
);

CREATE TABLE IdentifierType(
	ID INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
	type VARCHAR(40) NOT NULL UNIQUE,
	usability INT CHECK (usability IN (0, 1, 2)),
	price DECIMAL(9, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE Passenger(
	ID INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
	passengerName VARCHAR(50) NOT NULL,
	password VARCHAR(30)
);

CREATE TABLE Identifier (
    ID INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    validFrom DATETIME,
    validTo DATETIME,
    type INT,
    passenger INT,
    CONSTRAINT FK_IDENTIFIER_PASSENGER FOREIGN KEY (passenger) REFERENCES Passenger(ID) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT FK_IDENTIFIER_CARD_TYPE FOREIGN KEY (type) REFERENCES IdentifierType(ID) ON DELETE CASCADE ON UPDATE RESTRICT,
);

CREATE TABLE Validate(
	vehicle VARCHAR(20) NOT NULL REFERENCES Vehicle(registrationNumber) ON DELETE CASCADE ON UPDATE RESTRICT,
	identifier INT NOT NULL REFERENCES Identifier(ID) ON DELETE CASCADE ON UPDATE RESTRICT,
	validation DATETIME,
	PRIMARY KEY (vehicle, identifier)
);