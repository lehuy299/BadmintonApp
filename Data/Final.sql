/*create City:
- CityId existed : createCity-FK1

createCenter:
-CityId did not exist: createCityCenter - FK1
-CenterId existed : createCityCenter-FK2

createPlayer:
-PlayerId existed : createPlayer - FK1

createStaff:
-CityId did not exist : createStaff -FK1
-CenterId did not exist : createStaff -FK2
-StaffId existed : createStaff -FK3
-CenterId NOT belong to CityId : createStaff -001

createBooking:
-PlayerId did not exist : createBooking-FK1
-CityId did not exist : createBooking-FK2
-CenterId did not exist : createBooking-FK3
-CourtId did not exist : createBooking-FK4
-BookingId existed : createBooking-FK5
-StartTime in the past : createBooking-001
-StartTime before Opening time : createBooking-002
-EndTime after Closing time : createBooking-003
-StartTime after EndTime : createBooking-004
-Booking not 45,60,90 minutes: createBooking-005
-Center NOT belong to city : createBooking-006
-Court NOT belong to center :createBooking-007
-Booking overlap: createBooking-008
-3 Bookings in advance : createBooking-009
-1 pending booking in the past: createBooking-010

cancelBooking
-Booking did not exist : cancelBooking-FK1
-player did not exist : cancelBooking-FK2
-Booking NOT belong to Player cancelBooking-001
-Less than 24h before startTime cancelBooking-002

updateBookingStatus
-Booking did not exist : updateBookingStatus-FK1
-city did not exist : updateBookingStatus-FK2
-center did not exist : updateBookingStatus-FK3
-court did not exist : updateBookingStatus-FK4
-Booking NOT belong to center  : updateBookingStatus-001
-Center NOT belong to city: updateBookingStatus-002*/
DROP DATABASE booking_app;
CREATE DATABASE booking_app;
USE booking_app;

DROP TABLE IF EXISTS player;
CREATE TABLE player(
  player_id varchar(50) NOT NULL PRIMARY KEY,
  name varchar(50) UNIQUE
);

DROP TABLE IF EXISTS city;
CREATE TABLE city(
  city_id varchar(50) NOT NULL PRIMARY KEY,
  name varchar(50) UNIQUE
);

DROP TABLE IF EXISTS center;
CREATE TABLE center(
  center_id varchar(50) NOT NULL PRIMARY KEY,
  name varchar(50) UNIQUE,
  city varchar(50) NOT NULL,
  CONSTRAINT city_fk
     FOREIGN KEY (city) REFERENCES city (city_id)
);

DROP TABLE IF EXISTS staff;
CREATE TABLE staff(
	staff_id varchar(50) NOT NULL PRIMARY KEY,
    name varchar(50) UNIQUE,
	center varchar(50) NOT NULL,
    CONSTRAINT staff_center_id_fk
	FOREIGN KEY (center) REFERENCES center (center_id)
);
    
DROP TABLE IF EXISTS court;
CREATE TABLE court(
  court_id varchar(50) NOT NULL PRIMARY KEY,
  name varchar(50) UNIQUE,
  center varchar(50) NOT NULL,
   CONSTRAINT court_center_id_fk
     FOREIGN KEY (center) REFERENCES center (center_id)
);

DROP TABLE IF EXISTS booking;
CREATE TABLE booking(
  booking_id varchar(50) NOT NULL PRIMARY KEY,
  date date NOT NULL,
  startTime time NOT NULL,
  endTime time NOT NULL,
  court varchar(50) NOT NULL,
  player varchar(50) NOT NULL,
  booking_status boolean DEFAULT 0 , -- 0: UNPAID   1:PAID
  timestamp timestamp NOT NULL,
  CONSTRAINT court_fk
     FOREIGN KEY (court) REFERENCES court (court_id),
  CONSTRAINT player_fk
     FOREIGN KEY (player) REFERENCES player(player_id)	 
);
/*Create new City*/
DROP PROCEDURE IF EXISTS createCity;
DELIMITER //
CREATE PROCEDURE createCity(in pcity varchar(50))
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
  SELECT @p1, @p2;
  ROLLBACK;
END;
START TRANSACTION;
/* city existed */
IF pcity  IN (SELECT city_id from city)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createCity_FK1';

ELSE INSERT INTO city (city_id) values (pcity);
END IF;
END //
DELIMITER ;

/*Create new Center*/
DROP PROCEDURE IF EXISTS createCityCenter;
DELIMITER //
CREATE PROCEDURE createCityCenter(in pcity varchar(50), in pcenter varchar(50))
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
  SELECT @p1, @p2;
  ROLLBACK;
END;
START TRANSACTION;
/* city NOT exists */
IF pcity NOT IN (SELECT city_id from city)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createCenter_FK1';

/*Center existed*/
ELSEIF pcenter IN (SELECT center_id from center)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createCenter_FK2';
ELSE INSERT INTO center (center_id,city) values (pcenter,pcity);
END IF;
END //
DELIMITER ;

/*Create new Player*/
DROP PROCEDURE IF EXISTS createPlayer;
DELIMITER //
CREATE PROCEDURE createPlayer(in pplayer varchar(50))
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
  SELECT @p1, @p2;
  ROLLBACK;
END;
START TRANSACTION;
/* player existed */
IF pplayer  IN (SELECT player_id from player)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createPlayer_FK1';

ELSE INSERT INTO player (player_id) values (pplayer);
END IF;
END //
DELIMITER ;

/* Function check center belong to that city*/
DROP FUNCTION IF EXISTS Center_belongto_City;
DELIMITER //
CREATE FUNCTION Center_belongto_City(pcenter varchar(50),pcity varchar(50)) 
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

/*Create new Staff*/
DROP PROCEDURE IF EXISTS createStaff;
DELIMITER //
CREATE PROCEDURE createStaff(in pstaff varchar(50),in pcity varchar(50), in pcenter varchar(50))
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
  SELECT @p1, @p2;
  ROLLBACK;
END;
START TRANSACTION;
/* city NOT exists */
IF pcity NOT IN (SELECT city_id from city)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createStaff_FK1';

/*Center NOT exists*/
ELSEIF pcenter NOT IN (SELECT city_id from city)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createStaff_FK2';
/*Staff existed*/
ELSEIF pstaff IN (SELECT staff_id from staff)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createStaff_FK3';
ELSEIF NOT Center_belongto_City
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createStaff_001';
ELSE INSERT INTO staff (staff_id,center) values (pstaff,pcenter);
END IF;
END //
DELIMITER ;

/* Function check court belong to center */
DROP FUNCTION IF EXISTS Court_belongto_Center;
DELIMITER //
CREATE FUNCTION Court_belongto_Center(pcourt varchar(50),pcenter varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT 1
FROM court
WHERE court_id = pcourt AND center = pcenter
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

/* Create Booking*/
DROP PROCEDURE IF EXISTS createBooking;
DELIMITER //
CREATE PROCEDURE createBooking(in pbooking varchar(50),
in pdate date, in pstart time, in pend time,in pcity varchar(50),
 in pcenter varchar(50),in pcourt varchar(50), in pplayer varchar(50))
BEGIN
DECLARE openTime datetime;
DECLARE closeTime datetime;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
  SELECT @p1, @p2;
  ROLLBACK;
END;

SELECT 
  MAKETIME(7,0,0) into openTime;
SELECT 
  MAKETIME(21,0,0) into closeTime;  

START TRANSACTION;
/* player NOT exists */
IF pplayer NOT IN (SELECT player_id from player)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createBooking_FK1';

/* city NOT exists */
ELSEIF pcity NOT IN (SELECT city_id from city)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createBooking_FK2';

/* center NOT exists */
ELSEIF pcenter NOT IN (SELECT center_id from center)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createBooking_FK3';

/* court NOT exists */
ELSEIF pcourt NOT IN (SELECT court_id from court)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createBooking_FK4';

/* booking ALREADY exists */
ELSEIF pbooking IN (SELECT booking_id from booking)
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'createBooking_FK5';

/* start time in the past */
ELSEIF addtime(pdate,pstart) < date(now())
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'createBooking-001';

/* start time before opening time */
ELSEIF  pstart < openTime 
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'createBooking-002';

/* end time after closing time */
ELSEIF  pend > closeTime 
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'createBooking-003';

/*start time after end time */
ELSEIF pend < pstart
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'createBooking-004';

/*Booking must be 45/60/90 minutes*/
ELSEIF TIMESTAMPDIFF(MINUTE,pstart,pend) NOT IN (45,60,90)
THEN 
	SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'createBooking-005';

/*Center NOT belong to City*/
ELSEIF NOT Center_belongto_City(pcenter, pcity)
THEN 
	SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'createBooking-006';
 
/*Court NOT belong to Center*/
ELSEIF NOT Court_belongto_Center(pcourt,pcenter)
THEN 
	SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'createBooking-007'; 
/* Booking overlap*/
ELSEIF Overlap_Bookings (pdate,pstart,pend,pcourt)
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'createBooking-008';

/*More than 3 bookings in advance*/
ELSEIF Advance_Bookings (pplayer) >= 3
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CreateBooking-009';

/*Unpaid*/
ELSEIf Pending_Booking (pplayer)
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CreateBooking-010';

ELSE INSERT INTO booking (booking_id,date,startTime,endTime,court,player) values (pbooking,pdate,pstart,pend,pcourt,pplayer);
END IF;
END //
DELIMITER ;

/* Function check if booking is belonged to that player*/
DROP FUNCTION IF EXISTS Booking_belongto_Player;
DELIMITER //
CREATE FUNCTION Booking_belongto_Player(pbooking varchar(50),pplayer varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT 1
FROM booking
WHERE player = pplayer
AND  booking_id = pbooking
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

/* Cancel Booking */
DROP PROCEDURE IF EXISTS cancelBooking;
DELIMITER //
CREATE PROCEDURE cancelBooking(in pbooking varchar(50),in pplayer varchar(50))
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
  SELECT @p1, @p2;
  ROLLBACK;
END;
START TRANSACTION;
/* Booking id NOT exists */
IF pbooking NOT IN (
	SELECT booking_id
    FROM booking)
THEN SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'cancelBooking-FK1';   

/* Player id NOT exists */
ELSEIF pplayer NOT IN (
	SELECT player_id
    FROM player)
THEN SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'cancelBooking-FK2';

/* Booking NOT belong to Player*/
ELSEIF NOT Booking_belongto_Player (pbooking, pplayer)
THEN SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'cancelBooking-001';

/* less than 24h booking */
ELSEIF 24h_Booking (pbooking,pplayer)
THEN SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'cancelBooking-002';

ELSE DELETE FROM booking WHERE booking_id = pbooking AND player = pplayer ;
END IF;
END //
DELIMITER ;

/* Function check booking belong to court */
DROP FUNCTION IF EXISTS Booking_belongto_Center;
DELIMITER //
CREATE FUNCTION Booking_belongto_Center(pbooking varchar(50),pcenter varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT 1
FROM booking AS B
JOIN court AS CO ON B.court = CO.court_id
WHERE CO.center = pcenter
AND  B.booking_id = pbooking
INTO result;
RETURN result;
END //
DELIMITER ;

/*Update Booking Status*/
DROP PROCEDURE IF EXISTS updateBookingStatus;
DELIMITER //
CREATE PROCEDURE  updateBookingStatus(in pbooking varchar(50),in pstatus int,in pcity varchar(50),in pcenter varchar(50),in pstaff varchar(50))
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
  SELECT @p1, @p2;
  ROLLBACK;
END;
START TRANSACTION;
/* Booking id NOT exists */
IF pbooking NOT IN (
	SELECT booking_id
    FROM booking)
THEN SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'updateBookingStatus-FK1';   

/* City id NOT exists */
ELSEIF pcity NOT IN (
	SELECT city_id
    FROM city)
THEN SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'updateBookingStatus-FK2';

/* Center id NOT exists */
ELSEIF pcenter NOT IN (
	SELECT center_id
    FROM center)
THEN SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'updateBookingStatus-FK3';

/*Booking NOT belong to center*/
ELSEIF NOT Booking_belongto_Center(pbooking,pcenter)
THEN SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'updateBookingStatus-001';
 
 /*Center NOT belong to city*/
ELSEIF NOT Center_belongto_City (pcenter, pcity)
THEN SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'updateBookingStatus-002';
   
ELSE UPDATE booking
	SET booking_status = pstatus
    WHERE booking_id = pbooking;
END IF;
END //
DELIMITER ;
