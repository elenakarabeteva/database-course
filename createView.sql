-- СКГТ
-- Елена Карабетева, 6MI0700149

-- валидните билети спрямо текущата дата 
CREATE VIEW VALID_TICKETS AS
SELECT i.ID AS IdentifierID, t.type AS Type
FROM Identifier i
LEFT JOIN IdentifierType t ON i.type = t.ID
WHERE i.validFrom <= CURRENT_TIMESTAMP AND i.validTo >= CURRENT_TIMESTAMP;

SELECT * FROM VALID_TICKETS;

-- изглед, показващ началните и крайните спирки на превозното средство 
CREATE VIEW LINE_INFO_VIEW AS
SELECT l.lineNumber, s1.stopName AS startStop, s2.stopName AS lastStop
FROM Line l
JOIN Stops s1 ON l.startStop = s1.ID
JOIN Stops s2 ON l.lastStop = s2.ID;

SELECT * FROM LINE_INFO_VIEW
WHERE startStop LIKE 'МЕТРОСТАНЦИЯ%';

-- -- изглед, даващ информация за превозните средства
CREATE VIEW VEHICLE_INFO_VIEW AS
SELECT v.registrationNumber, l.lineNumber
FROM Vehicle v
JOIN Line l ON v.line = l.lineNumber;

SELECT * FROM VEHICLE_INFO_VIEW
WHERE lineNumber LIKE 'A[0-9]%';

-- изглед, показващ разписанието на всички линии, спирки, седмично и час на пристигане
CREATE VIEW SCHEDULE_VIEW AS
SELECT l.lineNumber, st.stopName AS stopName, s.inWeekday, s.arrivalTime
FROM Schedule s
JOIN Line l ON s.line = l.lineNumber
JOIN Stops st ON s.stop = st.ID;

SELECT * FROM SCHEDULE_VIEW
WHERE inWeekday = 1;
	
-- изглед, даващ информация за спирките
CREATE VIEW STOP_INFORMATION AS
SELECT stopName, latitude, longitude 
FROM Stops
WITH CHECK OPTION;

-- добавяне на нова спирка през изгледа
INSERT INTO STOP_INFORMATION
VALUES ('Ж.К. НАДЕЖДА', 42.663477, 23.349175);

SELECT * FROM STOP_INFORMATION;

-- изглед, показващ вида на билетите
CREATE VIEW TICKETS_TYPE AS
SELECT ID, type, price 
FROM IdentifierType
WHERE usability IS NULL;

-- изглед, показващ вида на картите
CREATE VIEW CARDS_TYPE AS
SELECT ID, type, price 
FROM IdentifierType
WHERE usability IS NOT NULL;

-- изглед, показващ информация за идентификаторите и техните притежатели
CREATE VIEW IDENTIFIER_PASSENGER_INFORMATION AS
SELECT i.validFrom, i.validTo, it.type, p.passengerName AS name
FROM Identifier i
JOIN IdentifierType it ON i.type = it.ID
JOIN Passenger p ON i.passenger = p.ID;

SELECT name, COUNT(name) AS identifierCount
FROM IDENTIFIER_PASSENGER_INFORMATION
GROUP BY name
ORDER BY identifierCount DESC;