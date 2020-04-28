/*Create new City*/
DROP PROCEDURE IF EXISTS createCity;
DELIMITER //
CREATE PROCEDURE createCity(in pcity varchar(50), out result int)
BEGIN
/*Invalid city*/
IF isValidId(pcity) = 0 
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
CREATE PROCEDURE createCityCenter(in pcity varchar(50), in pcenter varchar(50),in pmini int, out result int)
BEGIN
/*Invalid city*/
IF isValidId(pcity) = 0 
THEN SET result = 201;

/*Invalid center*/
ELSEIF isValidId(pcenter) = 0 
THEN SET result = 202;

/* city NOT exists */
ELSEIF pcity NOT IN (SELECT city_id FROM city)
THEN SET result = 203;

/*Center existed*/
ELSEIF pcenter IN (SELECT center_id FROM center WHERE city = pcity)
THEN SET result = 204;

ELSE INSERT INTO center (center_id,city,minimun_length) values (pcenter, pcity,pmini);
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
IF isValidId(pcity) = 0 
THEN SET result = 301;

/*Invalid center*/
ELSEIF isValidId(pcenter) = 0 
THEN SET result = 302;

/*Invalid court*/
ELSEIF isValidId(pcourt) = 0 
THEN SET result = 303;

/* city NOT exists */
ELSEIF pcity NOT IN (SELECT city_id FROM city)
THEN SET result = 304;

/* center NOT exists in that City */
ELSEIF pcenter NOT IN (SELECT center_id FROM center WHERE city = pcity) 
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
DECLARE openTime time;
DECLARE closeTime time;
DECLARE mini int;

SELECT openHour FROM opening_times WHERE center = pcenter AND city = pcity AND week_day = dayname(pdate)
   into openTime;
SELECT closeHour FROM opening_times WHERE center = pcenter AND city = pcity AND week_day = dayname(pdate)
   into closeTime;
SELECT minimun_length FROM center WHERE center_id = pcenter AND city = pcity into mini;

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
ELSEIF pcity NOT IN (SELECT city_id FROM city)
THEN SET result = 506;

/* center NOT exists in that city */
ELSEIF pcenter NOT IN (SELECT center_id FROM center WHERE city = pcity) 
THEN SET result = 507;

/* court NOT exists */
ELSEIF pcourt NOT IN (SELECT court_id FROM court WHERE center = pcenter AND city = pcity)
THEN SET result = 508;

/* start time in the past */
ELSEIF addtime(pdate,pstart) < now()
THEN SET result = 509;

/*Holiday*/
ELSEIF EXISTS (SELECT  * FROM holidays WHERE day(date) = day (pdate) and month (date) = month(pdate))
THEN SET result = 510;

/* start time before opening time */
ELSEIF  pstart < openTime 
THEN SET result = 511;

/* end time after closing time */
ELSEIF  pend > closeTime 
THEN SET result = 512;

/*start time after end time */
ELSEIF pend < pstart
THEN SET result = 513;

/*Booking not satisfy length */
ELSEIF mini > TIMESTAMPDIFF(MINUTE,pstart,pend) OR TIMESTAMPDIFF(MINUTE,pstart,pend) NOT IN (45,60,75,90)  
THEN SET result = 514;

/* Booking overlap*/
ELSEIF Overlap_Bookings (pdate,pstart,pend,pcourt)
THEN SET result = 515;

/*More than 3 bookings in advance*/
ELSEIF Advance_Bookings (pplayer) >= 3
THEN SET result = 516;

/*Unpaid*/
ELSEIF Pending_Booking (pplayer)
THEN SET result = 517;

ELSE INSERT INTO booking (date,startTime,endTime,court,city,center,player,timestamp) 
values (pdate,pstart,pend,pcourt,pcity,pcenter,pplayer,now());
	SET result = 500;
END IF;
SELECT RESULT;
END //
DELIMITER ;
