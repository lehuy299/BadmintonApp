DROP DATABASE booking_app;
CREATE DATABASE booking_app;
USE booking_app;

DROP TABLE IF EXISTS player;
CREATE TABLE player(
	player_id varchar(50) NOT NULL PRIMARY KEY,
    	name varchar(50) NOT NULL,
    	email varchar(100) NOT NULL
);

DROP TABLE IF EXISTS city;
CREATE TABLE city(
	city_id varchar(50) NOT NULL PRIMARY KEY
);

DROP TABLE IF EXISTS center;
CREATE TABLE center(
	center_id  varchar(50) NOT NULL,
	city varchar(50) NOT NULL,
    CONSTRAINT center_id_city_pk
		PRIMARY KEY (center_id,city),
	CONSTRAINT city_fk
		FOREIGN KEY (city) REFERENCES city (city_id)
);

DROP TABLE IF EXISTS staff;
CREATE TABLE staff(
	staff_id varchar(50) NOT NULL,
	center varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
	CONSTRAINT staff_id_center_pk
		PRIMARY KEY (staff_id,center,city),
	CONSTRAINT staff_center_id_fk
		FOREIGN KEY (center) REFERENCES center (center_id),
	CONSTRAINT staff_city_id_fk
		FOREIGN KEY (city) REFERENCES city (city_id)
);
    
DROP TABLE IF EXISTS court;
CREATE TABLE court(
	court_id varchar(50) NOT NULL,
	center varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    CONSTRAINT court_id_center_pk
		PRIMARY KEY (court_id,center,city),
	CONSTRAINT court_center_id_fk
		FOREIGN KEY (center) REFERENCES center (center_id),
    CONSTRAINT center_city_id_fk
		FOREIGN KEY (city) REFERENCES city (city_id)    
);

DROP TABLE IF EXISTS booking;
CREATE TABLE booking(
  booking_id varchar(50) NOT NULL PRIMARY KEY,
  date date NOT NULL,
  startTime time NOT NULL,
  endTime time NOT NULL,
  court varchar(50) NOT NULL,
  center varchar(50) NOT NULL,
  city varchar(50) NOT NULL,
  player varchar(50) NOT NULL,
  booking_status boolean DEFAULT 0 , -- 0: UNPAID   1:PAID
  timestamp timestamp NOT NULL,
  CONSTRAINT court_fk
     FOREIGN KEY (court) REFERENCES court (court_id),
  CONSTRAINT player_fk
     FOREIGN KEY (player) REFERENCES player(player_id)	 
);

