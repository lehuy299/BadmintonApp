/*Create new City*/
DROP PROCEDURE IF EXISTS createCity;
DELIMITER //
CREATE PROCEDURE createCity(in pcity varchar(50), out result int)
BEGIN
/*Invalid city*/
IF isValid(pcity) = 0 
THEN SET result = 101;

/*City existed*/
ELSEIF pcity  IN (SELECT city_id FROM city)
THEN SET result = 102;

ELSE INSERT INTO city (city_id) values (pcity);
SET result = 100;
END IF;
SELECT result;
END //
DELIMITER ;

/*Create new Center*/
DROP PROCEDURE IF EXISTS createCityCenter;
DELIMITER //
CREATE PROCEDURE createCityCenter(in pcity varchar(50), in pcenter varchar(50), out result int)
BEGIN
/*Invalid city*/
IF isValid(pcity) = 0 
THEN SET result = 201;

/*Invalid center*/
ELSEIF isValid(pcenter) = 0 
THEN SET result = 202;

/* city NOT exists */
ELSEIF pcity NOT IN (SELECT city_id FROM city)
THEN SET result = 203;

/*Center existed*/
ELSEIF Center_EXISTED_City(pcenter,pcity)
THEN SET result = 204;

ELSE INSERT INTO center (center_id,city) values (pcenter, pcity);
	SET result = 200;
END IF;
SELECT result;
END //
DELIMITER ;

/*Create new Court*/
DROP PROCEDURE IF EXISTS createCityCenterCourt;
DELIMITER //
CREATE PROCEDURE createCityCenterCourt(in pcourt varchar(50),in pcity varchar(50), in pcenter varchar(50), out result int)
BEGIN
/*Invalid city*/
IF isValid(pcity) = 0 
THEN SET result = 301;

/*Invalid center*/
ELSEIF isValid(pcenter) = 0 
THEN SET result = 302;

/*Invalid court*/
ELSEIF isValid(pcourt) = 0 
THEN SET result = 303;

/* city NOT exists */
ELSEIF pcity NOT IN (SELECT city_id FROM city)
THEN SET result = 304;

/* center NOT exists in that City */
ELSEIF NOT Center_EXISTED_City(pcenter,pcity)
THEN SET result = 305;

/* court existed */
ELSEIF EXISTS (SELECT court_id FROM court WHERE court_id= pcourt AND center = pcenter AND city = pcity)
THEN SET result = 306;

ELSE INSERT INTO court (court_id,center,city) values (pcourt,pcenter,pcity);
	SET result = 300;
END IF;
SELECT result;
END //
DELIMITER ;

/*Create new Player*/
DROP PROCEDURE IF EXISTS createPlayer;
DELIMITER //
CREATE PROCEDURE createPlayer(in pplayer varchar(50), out result int)
BEGIN
/*Invalid player*/
IF isValid(pplayer) = 0 
THEN SET result = 401;

/* player existed */
ELSEIF pplayer  IN (SELECT player_id FROM player)
THEN SET result = 402;

ELSE INSERT INTO player (player_id) values (pplayer);
SET result = 400;
END IF;
SELECT result;
END //
DELIMITER ;

/*Create new Staff*/
DROP PROCEDURE IF EXISTS createStaff;
DELIMITER //
CREATE PROCEDURE createStaff(in pstaff varchar(50),in pcity varchar(50), in pcenter varchar(50), out result int)
BEGIN
/*Invalid city*/
IF isValid(pcity) = 0 
THEN SET result =501;

/*Invalid center*/
ELSEIF isValid(pcenter) = 0 
THEN SET result = 502;

/*Invalid staff*/
ELSEIF isValid(pstaff) = 0 
THEN SET result = 503;

/* city NOT exists */
ELSEIF pcity NOT IN (SELECT city_id FROM city)
THEN SET result = 504;

/* center NOT exists */
ELSEIF NOT Center_EXISTED_City(pcenter,pcity)
THEN SET result = 505;

/*Staff existed*/
ELSEIF EXISTS (
	SELECT staff_id 
    FROM staff 
    WHERE center = pcenter AND staff_id = pstaff AND city = pcity)
THEN SET result = 506;

ELSE INSERT INTO staff (staff_id,city,center) values (pstaff,pcity,pcenter);
SET result = 500;
END IF;
SELECT result;
END //
DELIMITER ;

/* Create Booking*/
DROP PROCEDURE IF EXISTS createBooking;
DELIMITER //
CREATE PROCEDURE createBooking(in pbooking varchar(50),
in pdate date, in pstart time, in pend time,in pcity varchar(50),
 in pcenter varchar(50),in pcourt varchar(50), in pplayer varchar(50),out result int)
BEGIN
DECLARE openTime datetime;
DECLARE closeTime datetime;

SELECT 
  MAKETIME(7,0,0) into openTime;
SELECT 
  MAKETIME(21,0,0) into closeTime;  

/*Invalid booking*/
IF isValid(pbooking) = 0 
THEN SET result =601;

/*Invalid city*/
ELSEIF isValid(pcity) = 0 
THEN SET result =602;

/*Invalid center*/
ELSEIF isValid(pcenter) = 0 
THEN SET result = 603;

/*Invalid court*/
ELSEIF isValid(pcourt) = 0 
THEN SET result =604;

/*Invalid player*/
ELSEIF isValid(pplayer) = 0 
THEN SET result =605;

/* player NOT exists */
ELSEIF pplayer NOT IN (SELECT player_id FROM player)
THEN SET result = 606;

/* city NOT exists */
ELSEIF pcity NOT IN (SELECT city_id FROM city)
THEN SET result = 607;

/* center NOT exists in that city */
ELSEIF NOT Center_EXISTED_City(pcenter,pcity)
THEN SET result = 608;

/* court NOT exists */
ELSEIF pcourt NOT IN (SELECT court_id FROM court WHERE center = pcenter AND city = pcity)
THEN SET result = 609;

/* booking ALREADY exists */
ELSEIF pbooking IN (SELECT booking_id FROM booking)
THEN SET result = 610;

/* start time in the past */
ELSEIF addtime(pdate,pstart) < now()
THEN SET result = 611;

/* start time before opening time */
ELSEIF  pstart < openTime 
THEN SET result = 612;

/* end time after closing time */
ELSEIF  pend > closeTime 
THEN SET result = 613;

/*start time after end time */
ELSEIF pend < pstart
THEN SET result = 614;

/*Booking must be 45/60/90 minutes*/
ELSEIF TIMESTAMPDIFF(MINUTE,pstart,pend) NOT IN (45,60,75,90)
THEN SET result = 615;

/* Booking overlap*/
ELSEIF Overlap_Bookings (pdate,pstart,pend,pcourt)
THEN SET result = 618;

/*More than 3 bookings in advance*/
ELSEIF Advance_Bookings (pplayer) >= 3
THEN SET result = 619;

/*Unpaid*/
ELSEIf Pending_Booking (pplayer)
THEN SET result = 620;

ELSE INSERT INTO booking (booking_id,date,startTime,endTime,court,city,center,player,timestamp) 
values (pbooking,pdate,pstart,pend,pcourt,pcity,pcenter,pplayer,now());
	SET result = 600;
END IF;
SELECT RESULT;
END //
DELIMITER ;

/* Cancel Booking */
DROP PROCEDURE IF EXISTS cancelBooking;
DELIMITER //
CREATE PROCEDURE cancelBooking(in pbooking varchar(50),in pplayer varchar(50),out result int)
BEGIN
/*Invalid booking*/
IF isValid(pbooking) = 0 
THEN SET result =701;

/*Invalid player*/
ELSEIF isValid(pplayer) = 0 
THEN SET result =702;

/* Booking id NOT exists */
ELSEIF pbooking NOT IN (SELECT booking_id FROM booking)
THEN SET result =703; 

/* Player id NOT exists */
ELSEIF pplayer NOT IN (	SELECT player_id FROM player)
THEN SET result =704;

/* Booking NOT belong to Player*/
ELSEIF NOT EXISTS (SELECT booking_id FROM booking WHERE booking_id = pbooking AND player = pplayer)
THEN SET result =705;

/* less than 24h booking */
ELSEIF 24h_Booking (pbooking,pplayer)
THEN SET result =706;

ELSE DELETE FROM booking WHERE booking_id = pbooking AND player = pplayer ;
	SET result =700;
END IF;
SELECT result;
END //
DELIMITER ;

/*Update Booking Status*/
DROP PROCEDURE IF EXISTS updateBookingStatus;
DELIMITER //
CREATE PROCEDURE  updateBookingStatus(in pbooking varchar(50),in pstatus int,in pcity varchar(50),in pcenter varchar(50),in pstaff varchar(50),out result int)
BEGIN
/*Invalid booking*/
IF isValid(pbooking) = 0 
THEN SET result =801;

/*Invalid city*/
ELSEIF isValid(pcity) = 0 
THEN SET result =802;

/*Invalid center*/
ELSEIF isValid(pcenter) = 0 
THEN SET result =803;

/*Invalid staff*/
ELSEIF isValid(pstaff) = 0 
THEN SET result =804;

/* Booking id NOT exists */
ELSEIF pbooking NOT IN (
	SELECT booking_id
    FROM booking)
THEN SET result =805;

/* City id NOT exists */
ELSEIF pcity NOT IN (SELECT city_id FROM city)
THEN SET result =806;

/* Center id NOT exists */
ELSEIF NOT Center_EXISTED_City(pcenter,pcity)
THEN SET result =807;

/*Booking NOT belong to center*/
ELSEIF NOT EXISTS (SELECT booking_id FROM booking WHERE booking_id = pbooking AND center = pcenter)
THEN SET result =808;

/*Staff id NOT exists */
ELSEIF pstaff NOT IN (SELECT staff_id FROM staff WHERE city = pcity AND center = pcenter)
THEN SET result =809;
    
ELSE UPDATE booking
	SET booking_status = pstatus
    WHERE booking_id = pbooking;
    SET result =800;
END IF;
SELECT result;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS getAllCities;
DELIMITER //
CREATE PROCEDURE getAllCities(out result int)
BEGIN
/*There is no city */
IF NOT EXISTS (SELECT * FROM city)
THEN SET result = 901;

ELSE SELECT * FROM city;
SET result = 900;
END IF;
SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getAllCitiesCenters;
DELIMITER //
CREATE PROCEDURE getAllCitiesCenters(in pcity varchar(50),out result int)
BEGIN
/*Invalid city*/
IF isValid(pcity) = 0 
THEN SET result =1001;

/*There is no city */
ELSEIF NOT EXISTS (SELECT * FROM city)
THEN SET result = 1002;

/*There is no center in that city */
ELSEIF NOT EXISTS (SELECT * FROM center WHERE city = pcity)
THEN SET result = 1003;

ELSE SELECT * FROM center WHERE city = pcity;
SET result = 1000;
END IF;
SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getAllCitiesCentersCourts;
DELIMITER //
CREATE PROCEDURE getAllCitiesCentersCourts(in pcity varchar(50),in pcenter varchar(50),out result int)
BEGIN
/*Invalid city*/
IF isValid(pcity) = 0 
THEN SET result =1101;

/*Invalid center*/
ELSEIF isValid(pcenter) = 0 
THEN SET result =1102;

/*There is no city */
ELSEIF NOT EXISTS (SELECT * FROM city)
THEN SET result = 1103;

/* Center id NOT exists in that city */
ELSEIF NOT Center_EXISTED_City(pcenter,pcity)
THEN SET result =1105;

/*There is no court in that city */
ELSEIF NOT EXISTS (SELECT * FROM court WHERE city = pcity AND center = pcenter)
THEN SET result = 1106;

ELSE SELECT * FROM court WHERE city = pcity AND center = pcenter;
SET result = 1100;
END IF;
 SELECT result;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS getAllPlayers;
DELIMITER //
CREATE PROCEDURE getAllPlayers(out result int)
BEGIN
/*There is no player */
IF NOT EXISTS (SELECT * FROM player)
THEN SET result = 1201;

ELSE SELECT * FROM player;
SET result = 1200;
END IF;
SELECT result;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS getBookingInfo;
DELIMITER //
CREATE PROCEDURE getBookingInfo(in pbooking varchar(50),out result int)
BEGIN
/*Invalid booking*/
IF isValid(pbooking) = 0 
THEN SET result =1302;

/*booking_id not exist */
ELSEIF pbooking NOT IN (SELECT booking_id FROM booking)
THEN SET result = 1303;

ELSE SELECT court,center,city,date,startTime as "Start Time" ,endTime as "End Time", player FROM booking;
SET result = 1300;
END IF;
SELECT result;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS getCenterBooking;
DELIMITER //
CREATE PROCEDURE getCenterBooking(in pdate date, in pcenter varchar(50), in pcity varchar(50),out result int)
BEGIN
/*Invalid city*/
IF isValid(pcity) = 0 
THEN SET result =1401;

/*Invalid center*/
ELSEIF isValid(pcenter) = 0 
THEN SET result =1402;

/*city NOT exist */
ELSEIF NOT EXISTS (SELECT * FROM city)
THEN SET result = 1403;

/* Center id NOT exists in that city */
ELSEIF NOT Center_EXISTED_City(pcenter,pcity)
THEN SET result =1404;

/*There is no booking in that center on that date*/
ELSEIF NOT EXISTS (SELECT * FROM booking WHERE date = pdate AND Center_EXISTED_City(pcenter,pcity))
THEN SET result = 1405;

ELSE SELECT court,center,city,date,startTime as "Start Time" ,endTime as "End Time", player 
	FROM booking 
	WHERE date = pdate AND center = pcenter AND city = pcity ;
SET result = 1400;
END IF;
SELECT result;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS getPlayerBookings;
DELIMITER //
CREATE PROCEDURE getPlayerBookings(in pdate date, in pplayer varchar(50), in pcity varchar(50),out result int)
BEGIN
/*Invalid city*/
IF isValid(pcity) = 0 
THEN SET result =1501;

/*Invalid player*/
ELSEIF isValid(pplayer) = 0 
THEN SET result =1502;

/*There is no city */
ELSEIF NOT EXISTS (SELECT * FROM city)
THEN SET result = 1503;

/*player_Id NOT exist */
ELSEIF pplayer NOT IN (SELECT player_id FROM player)
THEN SET result = 1504;

/*There is no booking */
ELSEIF NOT EXISTS (SELECT * FROM booking)
THEN SET result = 1505;

/*There is no booking in that date of that player in that city*/
ELSEIF NOT EXISTS (SELECT * FROM booking WHERE date = pdate AND player = pplayer AND city = pcity )
THEN SET result = 1506;

ELSE SELECT court,center,city,date,startTime as "Start Time" ,endTime as "End Time", player 
	FROM booking 
	WHERE date = pdate AND player = pplayer AND city = pcity ;
    SET result = 1500;
END IF;
SELECT result;
END//
DELIMITER ;




