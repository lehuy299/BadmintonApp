/*Function check valid parameter*/
DROP FUNCTION IF EXISTS isValid;
DELIMITER //
CREATE FUNCTION isValid(pid varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT pid REGEXP '^[a-zA-Z0-9]+$' INTO result;
RETURN result;
END //
DELIMITER ;

/* Function check center belong to that city*/
DROP FUNCTION IF EXISTS Center_EXISTED_City;
DELIMITER //
CREATE FUNCTION Center_EXISTED_City(pcenter varchar(50),pcity varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT 1
FROM center
WHERE center_id = pcenter
AND city = pcity
INTO result;
RETURN result;
END //
DELIMITER ;

/* Function check overlap booking */
DROP FUNCTION IF EXISTS Overlap_Bookings;
DELIMITER //
CREATE FUNCTION Overlap_Bookings(pdate date,pstart time, pend time,
pcourt varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT 1 
FROM booking
WHERE court = pcourt
AND date = pdate
AND ((pstart <= startTime and pend > startTime)
	OR (pstart >=startTime and pstart < endTime))
INTO result;
RETURN result;
END //
DELIMITER ;

/* Function check 3 advance bookings */
DROP FUNCTION IF EXISTS Advance_Bookings;
DELIMITER //
CREATE FUNCTION Advance_Bookings(pplayer varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT count(*) 
FROM booking
WHERE player = pplayer
AND  date > date(now())
INTO result;
RETURN result;
END //
DELIMITER ;


/* Function check 1 pending bookings in the past */
DROP FUNCTION IF EXISTS Pending_Booking;
DELIMITER //
CREATE FUNCTION Pending_Booking(pplayer varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT 1
FROM booking
WHERE player = pplayer
AND  date <= date(now()) 
AND booking_status = 0
INTO result;
RETURN result;
END //
DELIMITER ;


/* Function check 24h booking for cancellation*/
DROP FUNCTION IF EXISTS 24h_Booking;
DELIMITER //
CREATE FUNCTION 24h_Booking(pbooking varchar(50),pplayer varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
	SELECT 1
	FROM booking 
	WHERE booking_id = pbooking AND player = pplayer 
    AND TIMESTAMPDIFF(HOUR,now(),addtime(date,startTime)) < 24
    INTO result;
RETURN result;
END //
DELIMITER ;
