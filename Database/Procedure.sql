/*Create new City*/
DROP PROCEDURE IF EXISTS createCity;
DELIMITER //
CREATE PROCEDURE createCity(in pcity varchar(50), out result int)
BEGIN
/*Invalid city*/
IF isValidId(pcity) = 0 
THEN SET result = 101;

/*City existed*/
ELSEIF pcity  IN (SELECT name FROM city)
THEN SET result = 102;

ELSE INSERT INTO city (name) values (pcity);
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
IF isValidId(pcity) = 0 
THEN SET result = 201;

/*Invalid center*/
ELSEIF isValidId(pcenter) = 0 
THEN SET result = 202;

/* city NOT exists */
ELSEIF pcity NOT IN (SELECT name FROM city)
THEN SET result = 203;

/*Center existed*/
ELSEIF pcenter IN (SELECT CE.name
					FROM center as CE
                    JOIN city as CI on CE.city = CI.city_id
                    WHERE CI.name = pcity)
THEN SET result = 204;

ELSE INSERT INTO center (name,city) values (pcenter,(SELECT city_id FROM city WHERE name= pcity));
	SET result = 200;
END IF;
SELECT result;
END //
DELIMITER ;


/*Create new court*/
DROP PROCEDURE IF EXISTS createCityCenterCourt;
DELIMITER //
CREATE PROCEDURE createCityCenterCourt(in pcourt varchar(50),in pcity varchar(50), in pcenter varchar(50), out result int)
BEGIN
/*Invalid city*/
IF isValidId(pcity) = 0 
THEN SET result = 301;

/*Invalid center*/
ELSEIF isValidId(pcenter) = 0 
THEN SET result = 302;

/*Invalid court*/
ELSEIF isValidId(pcourt) = 0 
THEN SET result = 303;

/* city NOT exists */
ELSEIF pcity NOT IN (SELECT name FROM city)
THEN SET result = 304;

/*Center NOT in that city*/
ELSEIF pcenter NOT IN (SELECT CE.name
					FROM center as CE
                    JOIN city as CI on CE.city = CI.city_id
                    WHERE CI.name = pcity)
THEN SET result = 305;

/* court existed */
ELSEIF EXISTS (SELECT *
					FROM court as CO
                    JOIN center as CE on CE.center_id = CO.center
                    JOIN city as CI on CE.city = CI.city_id
                    WHERE CI.name = pcity
                    AND CE.name = pcenter
                    AND CO.name = pcourt) 
THEN SET result = 306;

ELSE INSERT INTO court (name,center) values (pcourt,(
		SELECT CE.center_id 
        FROM center as CE
        JOIN city as CI on CE.city = CI.city_id
		WHERE CE.name= pcenter AND CI.name = pcity));
	SET result = 300;
END IF;
SELECT result;
END //
DELIMITER ;

/*Create new Player*/
DROP PROCEDURE IF EXISTS createPlayer;
DELIMITER //
CREATE PROCEDURE createPlayer(in pplayer varchar(50),in pname varchar(50), in pemail varchar(100), out result int)
BEGIN
/*Invalid player_id*/
IF isValidId(pplayer) = 0 
THEN SET result = 401;

/*Invalid player email*/
ELSEIF isValidName(pname) = 0 
THEN SET result = 402;

/*Invalid player email*/
ELSEIF isValidEmail(pemail) = 0 
THEN SET result = 403;

/* player existed */
ELSEIF pplayer IN (SELECT player_id FROM player)
THEN SET result = 404;

ELSE INSERT INTO player (player_id,name,email) values (pplayer,pname,pemail);
SET result = 400;
END IF;
SELECT result;
END //
DELIMITER ;

/* Create Booking*/
DROP PROCEDURE IF EXISTS createBooking;
DELIMITER //
CREATE PROCEDURE createBooking(in pdate date, in pstart time, in pend time,in pcity varchar(50),
 in pcenter varchar(50),in pcourt varchar(50), in pplayer varchar(50),out result int)
BEGIN
DECLARE openTime datetime;
DECLARE closeTime datetime;

SELECT 
  MAKETIME(7,0,0) into openTime;
SELECT 
  MAKETIME(21,0,0) into closeTime;  

/*Invalid city*/
IF isValidId(pcity) = 0 
THEN SET result =501;

/*Invalid center*/
ELSEIF isValidId(pcenter) = 0 
THEN SET result = 502;

/*Invalid court*/
ELSEIF isValidId(pcourt) = 0 
THEN SET result =503;

/*Invalid player*/
ELSEIF isValidId(pplayer) = 0 
THEN SET result =504;

/* player NOT exists */
ELSEIF pplayer NOT IN (SELECT player_id FROM player)
THEN SET result =505;

/* city NOT exists */
ELSEIF pcity NOT IN (SELECT name FROM city)
THEN SET result = 506;

/* center NOT exists in that city */
ELSEIF pcenter NOT IN (SELECT CE.name
					FROM center as CE
                    JOIN city as CI on CE.city = CI.city_id
                    WHERE CI.name = pcity) 
THEN SET result = 507;

/* court NOT exists */
ELSEIF NOT EXISTS (SELECT *
					FROM court as CO
                    JOIN center as CE on CE.center_id = CO.center
                    JOIN city as CI on CE.city = CI.city_id
                    WHERE CI.name = pcity
                    AND CE.name = pcenter
                    AND CO.name = pcourt) 
THEN SET result = 508;

/* start time in the past */
ELSEIF addtime(pdate,pstart) < now()
THEN SET result = 509;

/* start time before opening time */
ELSEIF  pstart < openTime 
THEN SET result = 510;

/* end time after closing time */
ELSEIF  pend > closeTime 
THEN SET result = 511;

/*start time after end time */
ELSEIF pend < pstart
THEN SET result = 512;

/*Booking must be 45/60/90 minutes*/
ELSEIF TIMESTAMPDIFF(MINUTE,pstart,pend) NOT IN (45,60,75,90)
THEN SET result = 513;

/* Booking overlap*/
ELSEIF Overlap_Bookings (pdate,pstart,pend,(SELECT CO.court_id FROM court as CO
                    JOIN center as CE on CE.center_id = CO.center
                    JOIN city as CI on CE.city = CI.city_id
                    WHERE CI.name = pcity
                    AND CE.name = pcenter
                    AND CO.name = pcourt))
THEN SET result = 514;

/*More than 3 bookings in advance*/
ELSEIF Advance_Bookings (pplayer) >= 3
THEN SET result = 515;

/*Unpaid*/
ELSEIf Pending_Booking (pplayer)
THEN SET result = 516;

ELSE INSERT INTO booking (date,startTime,endTime,court,player,timestamp) 
values (pdate,pstart,pend,(SELECT CO.court_id 
							FROM court as CO
							JOIN center as CE on CE.center_id = CO.center
							JOIN city as CI on CE.city = CI.city_id
							WHERE CI.name = pcity
							AND CE.name = pcenter
							AND CO.name = pcourt),pplayer,now());
	SET result = 500;
END IF;
SELECT RESULT;
END //
DELIMITER ;

/* Cancel Booking */
DROP PROCEDURE IF EXISTS cancelBooking;
DELIMITER //
CREATE PROCEDURE cancelBooking(in pbooking int,in pplayer varchar(50),out result int)
BEGIN

/*Invalid player*/
IF isValidId(pplayer) = 0 
THEN SET result =601;

/* Booking id NOT exists */
ELSEIF pbooking NOT IN (SELECT booking_id FROM booking)
THEN SET result =602; 

/* Player id NOT exists */
ELSEIF pplayer NOT IN (	SELECT player_id FROM player)
THEN SET result =603;

/* Booking NOT belong to Player*/
ELSEIF NOT EXISTS (SELECT booking_id FROM booking WHERE booking_id = pbooking AND player = pplayer)
THEN SET result =604;

/* less than 24h booking */
ELSEIF 24h_Booking (pbooking,pplayer)
THEN SET result =605;

ELSE DELETE FROM booking WHERE booking_id = pbooking AND player = pplayer ;
	SET result =600;
END IF;
SELECT result;
END //
DELIMITER ;

/*Update Booking Status*/
DROP PROCEDURE IF EXISTS updateBookingStatus;
DELIMITER //
CREATE PROCEDURE  updateBookingStatus(in pbooking int,in pstatus int,in pcity varchar(50),in pcenter varchar(50),out result int)
BEGIN

/*Invalid city*/
IF isValidId(pcity) = 0 
THEN SET result =701;

/*Invalid center*/
ELSEIF isValidId(pcenter) = 0 
THEN SET result =702;

/* Booking id NOT exists */
ELSEIF pbooking NOT IN (
	SELECT booking_id
    FROM booking)
THEN SET result =703;

/* City id NOT exists */
ELSEIF pcity NOT IN (SELECT name FROM city)
THEN SET result =704;

/* Center id NOT exists in that city */
ELSEIF pcenter NOT IN (SELECT CE.name
					FROM center as CE
                    JOIN city as CI on CE.city = CI.city_id
                    WHERE CI.name = pcity) 

THEN SET result =705;

/*Booking NOT belong to center*/
ELSEIF NOT EXISTS (SELECT B.booking_id 
				FROM booking AS B
                JOIN court as CO on CO.court_id = B.court
				JOIN center as CE on CE.center_id = CO.center
				JOIN city as CI on CI.city_id = CE.city
				WHERE B.booking_id = pbooking AND CE.name = pcenter AND CI.name =pcity)
	
THEN SET result =706;

    
ELSE UPDATE booking
	SET booking_status = pstatus
    WHERE booking_id = pbooking;
    SET result =700;
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
THEN SET result = 801;

ELSE SELECT * FROM city;
SET result = 800;
END IF;
SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getAllCitiesCenters;
DELIMITER //
CREATE PROCEDURE getAllCitiesCenters(in pcity varchar(50),out result int)
BEGIN
/*Invalid city*/
IF isValidId(pcity) = 0 
THEN SET result =901;

/*city NOT exist */
ELSEIF pcity NOT IN (SELECT name FROM city)
THEN SET result = 902;

/*There is no center in that city */
ELSEIF NOT EXISTS (SELECT * 
				   FROM center AS CE 
				   JOIN city AS CI on CE.city = CI.city_id
                   WHERE CI.name = pcity)
THEN SET result = 903;

ELSE SELECT CE.center_id, CE.name,CI.name FROM center AS CE 
			  JOIN city AS CI on CE.city = CI.city_id
			  WHERE CI.name = pcity;
SET result = 900;
END IF;
SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getAllCitiesCentersCourts;
DELIMITER //
CREATE PROCEDURE getAllCitiesCentersCourts(in pcity varchar(50),in pcenter varchar(50),out result int)
BEGIN
/*Invalid city*/
IF isValidId(pcity) = 0 
THEN SET result =1001;

/*Invalid center*/
ELSEIF isValidId(pcenter) = 0 
THEN SET result =1002;

/*city NOT exist */
ELSEIF pcity NOT IN (SELECT name FROM city)
THEN SET result = 1003;

/* Center id NOT exists in that city */
ELSEIF NOT EXISTS (SELECT * 
				   FROM center AS CE 
				   JOIN city AS CI on CE.city = CI.city_id
                   WHERE CI.name = pcity
                   AND CE.name = pcenter)
THEN SET result =1004;

ELSE SELECT CO.court_id,CO.name,CE.name,CI.name 
	FROM court as CO
	JOIN center as CE on CE.center_id = CO.center
    JOIN city as CI on CE.city = CI.city_id 
    WHERE CI.name = pcity AND CE.name = pcenter;
SET result = 1000;
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
THEN SET result = 1101;

ELSE SELECT * FROM player;
SET result = 1100;
END IF;
SELECT result;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS getBookingInfo;
DELIMITER //
CREATE PROCEDURE getBookingInfo(in pbooking int,out result int)
BEGIN

/*booking_id not exist */
IF pbooking NOT IN (SELECT booking_id FROM booking)
THEN SET result = 1201;

ELSE SELECT B.booking_id,CO.name,CE.name,CI.name,B.date,B.startTime as "Start Time" ,B.endTime as "End Time", P.name
	FROM booking AS B
    JOIN court AS CO on CO.court_id= B.court
    JOIN center as CE on CE.center_id = CO.center
    JOIN city as CI on CE.city = CI.city_id 
    JOIN player as P on P.player_id = B.player
    WHERE B.booking_id = pbooking;
SET result = 1200;
END IF;
SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getCenterBooking;
DELIMITER //
CREATE PROCEDURE getCenterBooking(in pdate date, in pcenter varchar(50), in pcity varchar(50),out result int)
BEGIN
/*Invalid city*/
IF isValidId(pcity) = 0 
THEN SET result =1301;

/*Invalid center*/
ELSEIF isValidId(pcenter) = 0 
THEN SET result =1302;

/*city NOT exist */
ELSEIF pcity NOT IN (SELECT name FROM city)
THEN SET result = 1303;

/* Center id NOT exists in that city */
ELSEIF pcenter NOT IN (SELECT CE.name
					FROM center as CE
                    JOIN city as CI on CE.city = CI.city_id
                    WHERE CI.name = pcity )
THEN SET result =1304;

/*There is no booking in that center on that date*/
ELSEIF NOT EXISTS (SELECT * 
				FROM booking AS B
                JOIN court as CO on CO.court_id = B.court
				JOIN center as CE on CE.center_id = CO.center
				JOIN city as CI on CI.city_id = CE.city
				WHERE B.date = pdate AND CE.name = pcenter AND CI.name =pcity)
THEN SET result = 1305;

ELSE SELECT CE.name,CI.name,B.date,B.startTime as "Start Time" ,B.endTime as "End Time",P.name 
	FROM booking AS B
	JOIN court as CO on CO.court_id = B.court
	JOIN center as CE on CE.center_id = CO.center
	JOIN city as CI on CI.city_id = CE.city
    JOIN player as P on P.player_id = B.player
	WHERE B.date = pdate AND CE.name = pcenter AND CI.name = pcity ;
SET result = 1300;
END IF;
SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getCourtBooking;
DELIMITER //
CREATE PROCEDURE getCourtBooking(in pdate date,in pcourt varchar(50), in pcenter varchar(50), in pcity varchar(50),out result int)
BEGIN
/*Invalid city*/
IF isValidId(pcity) = 0 
THEN SET result =1401;

/*Invalid center*/
ELSEIF isValidId(pcenter) = 0 
THEN SET result =1402;
/*Invalid court*/
ELSEIF isValidId(pcourt) = 0 
THEN SET result =1403;

/*city NOT exist */
ELSEIF pcity NOT IN (SELECT name FROM city)
THEN SET result = 1404;

/* Center id NOT exists in that city */
ELSEIF pcenter NOT IN (SELECT CE.name
					FROM center as CE
                    JOIN city as CI on CE.city = CI.city_id
                    WHERE CI.name = pcity)
THEN SET result =1405;

/* Court id NOT exists in that center */
ELSEIF NOT EXISTS (SELECT *
					FROM court as CO
                    JOIN center as CE on CE.center_id = CO.center
                    JOIN city as CI on CE.city = CI.city_id
                    WHERE CI.name = pcity
                    AND CE.name = pcenter
                    AND CO.name = pcourt)  
THEN SET result =1406;

/*There is no booking in that center on that date*/
ELSEIF NOT EXISTS (SELECT * 
				FROM booking AS B
                JOIN court as CO on CO.court_id = B.court
				JOIN center as CE on CE.center_id = CO.center
				JOIN city as CI on CI.city_id = CE.city
				WHERE B.date = pdate 
                AND CO.name = pcourt 
                AND CE.name = pcenter 
                AND CI.name = pcity)
THEN SET result = 1407;

ELSE SELECT CO.name,CE.name,CI.name,B.date,B.startTime as "Start Time" ,B.endTime as "End Time",P.name 
	FROM booking AS B
	JOIN court as CO on CO.court_id = B.court
	JOIN center as CE on CE.center_id = CO.center
	JOIN city as CI on CI.city_id = CE.city
    JOIN player as P on P.player_id = B.player
	WHERE B.date = pdate AND CE.name = pcenter AND CI.name = pcity AND CO.name = pcourt;
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
IF isValidId(pcity) = 0 
THEN SET result =1501;

/*Invalid player*/
ELSEIF isValidId(pplayer) = 0 
THEN SET result =1502;

/*city NOT exist */
ELSEIF pcity NOT IN (SELECT name FROM city)
THEN SET result = 1503;

/*player_Id NOT exist */
ELSEIF pplayer NOT IN (SELECT player_id FROM player)
THEN SET result = 1504;

/*There is no booking in that date of that player in that city*/
ELSEIF NOT EXISTS (SELECT *
	FROM booking AS B
	JOIN court as CO on CO.court_id = B.court
	JOIN center as CE on CE.center_id = CO.center
	JOIN city as CI on CI.city_id = CE.city
    JOIN player as P on P.player_id = B.player
	WHERE CI.name = pcity AND P.player_id = pplayer AND B.date = pdate)
THEN SET result = 1505;

ELSE SELECT CI.name,B.date,B.startTime as "Start Time" ,B.endTime as "End Time",P.name 
	FROM booking AS B
	JOIN court as CO on CO.court_id = B.court
	JOIN center as CE on CE.center_id = CO.center
	JOIN city as CI on CI.city_id = CE.city
    JOIN player as P on P.player_id = B.player
	WHERE CI.name = pcity AND P.player_id = pplayer AND B.date = pdate;
    SET result = 1500;
END IF;
SELECT result;
END//
DELIMITER ;




