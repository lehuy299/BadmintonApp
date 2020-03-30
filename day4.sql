DROP DATABASE booking_app;
CREATE DATABASE booking_app;
USE booking_app;

DROP TABLE IF EXISTS customer;
CREATE TABLE customer(
  customer_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(50) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS city;
CREATE TABLE city(
  city_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(50) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS center;
CREATE TABLE center(
  center_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(50) NOT NULL UNIQUE,
  city int,
  CONSTRAINT city_fk
     FOREIGN KEY (city) REFERENCES city (city_id)
);

DROP TABLE IF EXISTS court;
CREATE TABLE court(
  court_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(50) NOT NULL UNIQUE,
  center int,
   CONSTRAINT center_id_fk
     FOREIGN KEY (center) REFERENCES center (center_id)
);

DROP TABLE IF EXISTS booking;
CREATE TABLE booking(
  booking_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date date NOT NULL,
  startHour int NOT NULL,
  endHour int NOT NULL,
  startMin int NOT NULL,
  endMin int NOT NULL,
  court int,
  customer int,
  payment_status varchar(6) NOT NULL, 
  timestamp timestamp NOT NULL,
  CONSTRAINT court_fk
     FOREIGN KEY (court) REFERENCES court (court_id),
  CONSTRAINT customer_fk
     FOREIGN KEY (customer) REFERENCES customer (customer_id)	 
);

/* Create Booking*/
DROP PROCEDURE IF EXISTS CreateBooking;
DELIMITER //
CREATE PROCEDURE CreateBooking(
in pdate date, 
in pstartHour int, in pstartMin int, 
in pendHour int, in pendMin int, 
in pcourt varchar(50), in pcustomer varchar(50), in ptimestamp timestamp)
BEGIN
DECLARE TotalBookings int;
DECLARE openTime datetime;
DECLARE closeTime datetime;
DECLARE startTime datetime;
DECLARE endTime datetime;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
  SELECT @p1, @p2;
  ROLLBACK;
END;

SELECT 
  date_add(date_add(pdate, INTERVAL 7 HOUR), INTERVAL 0 MINUTE)
  into openTime;
SELECT 
  date_add(date_add(pdate, INTERVAL 21 HOUR), INTERVAL 0 MINUTE)
  into closeTime;  
SELECT 
  date_add(date_add(pdate, INTERVAL pstartHour HOUR), INTERVAL pstartMin MINUTE)
  into startTime;
SELECT 
  date_add(date_add(pdate, INTERVAL pendHour HOUR), INTERVAL pendMin MINUTE)
  into endTime;
SELECT 
  count(*) 
FROM booking_app.booking as B 
	JOIN booking_app.customer as C ON B.customer = C.customer_id
WHERE C.name = pcustomer and B.payment_status like upper("UNPAID")
  into TotalBookings;  
START TRANSACTION;
IF startTime < DATE(NOW())
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Can not book a court in the past!';
END IF;
IF  startTime < openTime 
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Center is not open yet!';
END IF;
IF  endTime > closeTime 
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Center closed!';
END IF;

IF endTime < startTime 
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Start time can not after end time!';
END IF;

IF TIMESTAMPDIFF(MINUTE,startTime,endTime) < 45 
THEN 
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Booking must be longer than 45 minutes';
ELSEIF TIMESTAMPDIFF(MINUTE,startTime,endTime) > 90
THEN 
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Booking must not be longer than 90 minutes';
END IF;

IF TotalBookings >= 3
THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Customer have 3 unpaid booking';
ELSEIF TotalBookings = 1 and EXISTS (
									SELECT * 
                                    FROM booking_app.booking as B 
										JOIN booking_app.customer as C ON B.customer = C.customer_id
                                    WHERE C.name = pcustomer 
                                    AND date_add(date_add(B.date, INTERVAL B.startHour HOUR), INTERVAL B.startMin MINUTE) < date(now()))
THEN 
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Customer have 1 pending booking in the past';
END IF;
END //
DELIMITER ;

/* scenario */
INSERT INTO city (name) values ("City#1");
INSERT INTO city (name) values ("City#2");
INSERT INTO city (name) values ("City#3");

INSERT INTO center (name,city) values ("Center#1",1);
INSERT INTO center (name,city) values ("Center2",2);
INSERT INTO center (name,city) values ("Center3",3);

INSERT INTO court (name,center) values ("Court#1",1);
INSERT INTO court (name,center) values ("Court#2",2);
INSERT INTO court (name,center) values ("Court#3",3);

INSERT INTO customer (name) values ("Customer#A");
INSERT INTO customer (name) values ("Customer#B");
INSERT INTO customer (name) values ("Customer#C");





INSERT INTO booking (date,startHour,endHour,startMin,endMin,court,customer,payment_status,timestamp)
values ("2020-03-31",20,21,00,30,2,1,"Unpaid","2020-02-28 14:13:00");
INSERT INTO booking (date,startHour,endHour,startMin,endMin,court,customer,payment_status,timestamp)
values ("2020-04-30",15,16,00,30,1,1,"Unpaid","2020-02-28 20:20:00");
INSERT INTO booking (date,startHour,endHour,startMin,endMin,court,customer,payment_status,timestamp)
values ("2020-05-29",11,13,25,30,2,1,"Unpaid","2020-02-28 14:13:00");
INSERT INTO booking (date,startHour,endHour,startMin,endMin,court,customer,payment_status,timestamp)
values ("2020-03-29",10,13,25,30,2,2,"Paid","2020-02-28 14:13:00");
INSERT INTO booking (date,startHour,endHour,startMin,endMin,court,customer,payment_status,timestamp)
values ("2020-03-31",9,11,25,30,3,2,"Unpaid","2020-02-28 14:13:00");

/*tests */
call CreateBooking("2020-01-01", 7, 0, 8, 0, "Court#1", "Customer#A", 
    "2020-03-29 09:29:00");
	/* error: Booking date is in the past */
call CreateBooking("2020-04-01", 6, 0, 8, 0, "Court#1", "Customer#A", 
	"2020-03-29 09:27:00");
   /* error: Start Time before the center's opening time*/    
call CreateBooking("2020-04-01", 7, 0, 21, 15, "Court#1", "Customer#A", 
	"2020-03-29 09:27:00");
   /* error: End time after the */
call CreateBooking("2020-04-01", 8, 0, 7, 0, "Court#1", "Customer#A", 
	"2020-03-29 09:27:00");
   /* error: Start time can not after end time */
call CreateBooking("2020-04-05",17,30,18,0,"Court#3","Customer#C","2020-02-20 15:50:00");
   /* error : Booking can not be less than 45 minutes */
call CreateBooking("2020-04-05",15,30,18,0,"Court#3","Customer#C","2020-02-20 15:50:00");
/* error : Booking must not be longer than 90 minutes */
call CreateBooking("2020-04-05", 8, 0, 10, 0, "Court#1","Customer#A","2020-03-29 09:27:00");
   /*error : Customer had 3 unpaid booking*/
call CreateBooking("2020-04-05",11,30,13,00,"Court#1","Customer#B","2020-03-30 15:30:00");
   /*error : Customer had 1 pending booking in the past*/

/* Cancel Booking */
DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER //
CREATE PROCEDURE CancelBooking(in pbooking int)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
  SELECT @p1, @p2;
  ROLLBACK;
END;
START TRANSACTION;
IF  pbooking NOT IN (
	SELECT booking_id
    FROM booking_app.booking)
THEN SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Booking did not exist';
END IF;
IF TIMESTAMPDIFF(HOUR,(
	SELECT date_add(date_add(date, INTERVAL startHour HOUR), INTERVAL startMin MINUTE) 
	FROM booking_app.booking 
	WHERE booking_id= pbooking ),date(now())) < 24
THEN SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Customer can only cancel booking more than 24 hours before start time!';
END IF;

END //
DELIMITER ;

/* test */
call CancelBooking(5);
/*error: Customer can only cancel booking more than 24 hours before start time*/
CALL CancelBooking(7);
/*error: Booking did not exist*/
