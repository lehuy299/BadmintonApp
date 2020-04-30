/*Create City*/
call createCity("CityA",@a);/*success*//*100*/
call createCity("CityB",@a);/*sucess*//*100*/
call createCity("CityC",@a);/*success*//*100*/
call createCity("CityA",@a);/*city existed*//*102*/
call createCity("!@#",@a);/*Invalid city_id*//*101*/

/*Create Center*/
call createCityCenter("CityB","Center1",@a);/*Success*//*200*/
call createCityCenter("CityA","Center1",@a);/*Success*/ /*200*/
call createCityCenter("CityA","Center2",@a);/*Success*/ /*200*/
call createCityCenter("CityA","Center1",@a);/*Center existed*//*204*/
call createCityCenter("@$%","Center3",@a);/*Invaild city_id*//*201*/
call createCityCenter("CityA","!@#",@a);/*Invaild center_id*//*202*/
call createCityCenter("CityD","Center3",@a);/*City not existed*//*203*/

/*Create Court*/
call createCityCenterCourt("!@$","CityA","Center3",@a);/*Invalid court_id*//*303*/
call createCityCenterCourt("Court2","!@$","Center3",@a);/*Invalid city_id*//*301*/
call createCityCenterCourt("Court2","CityA","!@%",@a);/*Invalid center_id*//*302*/
call createCityCenterCourt("Court1","CityA","Center1",@a);/*Success*//*300*/
call createCityCenterCourt("Court2","CityA","Center1",@a);/*Success*//*300*/
call createCityCenterCourt("Court2","CityA","Center1",@a);/* Court existed*//*306*/
call createCityCenterCourt("Court2","CityD","Center3",@a);/*City not existed*//*304*/
call createCityCenterCourt("Court2","CityA","Center3",@a);/*Center not in that city*//*305*/

/*Create PLayer*/
call createPlayer("!@$!@","Huong","huongnguyenquynh2210@gmail.com",@a);/*Invalid player_id*//*401*/
call createPlayer("Player5","124  ","huongnguyenquynh2210@gmail.com",@a);/*Invalid player name*//*402*/
call createPlayer("Player2","Huong","@sdaf ",@a);/*Invalid player_email*//*403*/
call createPlayer("Player2","Nguyen","huongnguyenquynh2210@gmail.com",@a);/*Success*//*400*/
call createPlayer("Player1","Nguyen Quynh Huong","huongnguyenquynh2210@gmail.com",@a);/*Success*//*400*/
call createPlayer("Player1","Nguyen Quynh Huong","huongnguyenquynh2210@gmail.com",@a);/*Player existed*//*404*/
call createPlayer("Player3","Quynh","huongnguyenquynh2210@gmail.com",@a);/*Success*//*400*/

/*Create Booking*/
/*Existed : "Booking1","2020-02-12","7:00:00","8:00:00","Court2","Center3","CityA","Player1",unpaid*/
insert into booking(date,startTime,endTime,court,player,timestamp) values ("2020-02-12","7:00:00","8:00:00",1,"Player1",now());
CALL createBooking("2020-05-10","12:30:00","14:00:00","!@$","Center3","Court2","Player2",@a);/*Invalid city_id*//*501*/
CALL createBooking("2020-05-10","12:30:00","14:00:00","CityA","!@$","Court2","Player2",@a);/*Invalid center_id*//*502*/
CALL createBooking("2020-05-10","12:30:00","14:00:00","CityA","Center3","%!@#%","Player2",@a);/*Invalid court_id*//*503*/
CALL createBooking("2020-05-10","12:30:00","14:00:00","CityA","Center3","Court2","1@%#",@a);/*Invalid player_id*//*504*/
CALL createBooking("2020-05-12","7:00:00","8:00:00","CityA","Center1","Court2","Player2",@a);/*Success*//*500*/
CALL createBooking("2020-05-12","11:30:00","12:15:00","CityA","Center1","Court2","Player2",@a);/*Success*//*500*/
CALL createBooking("2020-05-12","12:30:00","13:30:00","CityA","Center1","Court2","Player2",@a);/*Success*//*500*/
CALL createBooking("2020-05-12","12:30:00","14:00:00","CityA","Center3","Court2","Player5",@a);/*Player not exist*//*505*/
CALL createBooking("2020-05-12","12:30:00","14:00:00","CityD","Center3","Court2","Player2",@a);/*City not exist*//*506*/
CALL createBooking("2020-05-12","12:30:00","14:00:00","CityA","Center3","Court2","Player2",@a);/*Center not exist in that city*//*507*/
CALL createBooking("2020-05-12","12:30:00","14:00:00","CityA","Center2","Court1","Player2",@a);/*Court not exist in that center*//*508*/
CALL createBooking("2020-01-09","7:30:00","9:00:00","CityA","Center1","Court2","Player2",@a);/*start time in the past*//*509*/
CALL createBooking("2020-05-12","6:30:00","8:00:00","CityA","Center1","Court2","Player2",@a);/*Start time before opening time*//*510*/
CALL createBooking("2020-05-12","20:30:00","22:00:00","CityA","Center1","Court2","Player2",@a);/*End time after closing time*//*511*/
CALL createBooking("2020-05-12","12:30:00","10:00:00","CityA","Center1","Court2","Player2",@a);/*End time before start time*//*512*/
CALL createBooking("2020-05-12","7:30:00","10:00:00","CityA","Center1","Court2","Player2",@a);/*Booking time must be 45/60/75/90 minutes*//*513*/
CALL createBooking("2020-05-12","7:30:00","8:00:00","CityA","Center1","Court2","Player2",@a);/*Booking time must be 45/60/75/90 minutes*//*513*/
CALL createBooking("2020-05-12","7:00:00","8:20:00","CityA","Center1","Court2","Player2",@a);/*Booking time must be 45/60/75/90 minutes*//*513*/
CALL createBooking("2020-05-12","7:15:00","8:00:00","CityA","Center1","Court2","Player3",@a);/*Overlap booking*//*514*/
CALL createBooking("2020-05-12","11:00:00","12:15:00","CityA","Center1","Court2","Player3",@a);/*Overlap booking*//*514*/
CALL createBooking("2020-05-12","10:45:00","12:15:00","CityA","Center1","Court2","Player3",@a);/*Overlap booking*//*514*/
CALL createBooking("2020-05-17","11:30:00","13:00:00","CityA","Center1","Court2","Player2",@a);/*More than 3 bookings*//*515*/
CALL createBooking("2020-05-15","11:30:00","13:00:00","CityA","Center1","Court1","Player1",@a);/*Pending booking in the past*//*516*/
CALL createBooking("2020-05-01","7:30:00","8:30:00","CityA","Center1","Court2","Player3",@a);/*Success*/

/*Cancel Booking */
call cancelBooking(1,"#$$",@a);/*Invalid player_id*//*601*/
call cancelBooking(2,"Player2",@a);/*Success*//*600*/
call cancelBooking(2,"Player2",@a);/*Booking not existed*//*602*/
call cancelBooking(7,"Player2",@a);/*Booking not existed*//*602*/
call cancelBooking(1,"Player5",@a);/*player not existed*//*603*/
call cancelBooking(1,"Player2",@a);/*Booking NOT belong to Player*//*604*/
call cancelBooking(5,"Player3",@a);/*less than 24h from start time *//*605*/

/*UpdateBookingStatus*/

call updateBookingStatus(1,1,"!@!@#","Center3",@a);/*Invalid city_id*//*701*/
call updateBookingStatus(1,1,"CityA","#!$",@a);/*Invalid center_id*//*702*/
call updateBookingStatus(1,1,"CityA","Center1",@a);/*Success*//*700*/
call updateBookingStatus(7,1,"CityA","Center3",@a);/*Booking_id not exist*//*703*/
call updateBookingStatus(1,1,"CityD","Center3",@a);/*City_id not exist*//*704*/
call updateBookingStatus(1,1,"CityA","Center3",@a);/*Center_id not exist in that city*//*705*/
call updateBookingStatus(1,1,"CityA","Center2",@a);/*Booking NOT belong to center*//*706*/


/*Get all cities*/
call getAllCities(@a);/*Success*//*800*/

/*Get all center in that city*/
call getAllCitiesCenters("!@$",@a);/*Invalid city_id*//*901*/
call getAllCitiesCenters("CityB",@a);/*Success*//*900*/
call getAllCitiesCenters("CityCG",@a);/*City not exist*//*902*/
call getAllCitiesCenters("CityC",@a);/*No center in that city*//*903*/

/*Get all court in that center*/
call getAllCitiesCentersCourts("1@#!@","Center3",@a);/*Invalid city_id*//*1001*/
call getAllCitiesCentersCourts("CityA","4!@$",@a);/*Invalid center_id*//*1002*/
call getAllCitiesCentersCourts("CityA","Center1",@a);/*Success*//*1000*/
call getAllCitiesCentersCourts("CityG","Center3",@a);/*City not exist*//*1003*/
call getAllCitiesCentersCourts("CityB","Center2",@a);/*Center_id not exist in that city*//*1004*/

/*Get all players*/
call getAllPlayers(@a);

/*Get Booking Info*/
call getBookingInfo(1,@a);/*Success*//*1200*/
call getBookingInfo(6,@a);/*Booking_id not existed*//*1201*/

/*Get Center Booking*/
call getCenterBooking("2020-05-14","!@#%","CityA",@a);/*Invalid center_id*//*1302*/
call getCenterBooking("2020-05-14","Center3","$#",@a);/*Invalid city_id*//*1301*/
call getCenterBooking("2020-05-12","Center1","CityA",@a);/*Success*//*1300*/
call getCenterBooking("2020-02-14","Center1","CityA",@a);/*No booking on that date at the center*//*1305*/
call getCenterBooking("2020-02-14","Center2","CityB",@a);/*Center_id not in that city*//*1304*/
call getCenterBooking("2020-02-14","Center2","CityD",@a);/*City NOT exist*//*1303*/

/*Get Center Booking*/
call getCourtBooking("2020-05-14","Court2","!@#%","CityA",@a);/*Invalid center_id*//*1402*/
call getCourtBooking("2020-05-14","Court2","Center3","$#",@a);/*Invalid city_id*//*1401*/
call getCourtBooking("2020-05-14","&Court2","Center3","CityA",@a);/*Invalid court_id*//*1403*/
call getCourtBooking("2020-05-12","Court2","Center1","CityA",@a);/*Success*//*1400*/
call getCourtBooking("2020-05-14","Court3","Center2","CityA",@a);/*Court not exist*//*1406*/
call getCourtBooking("2020-02-15","Court2","Center1","CityA",@a);/*No booking on that date at the center*//*1407*/
call getCourtBooking("2020-02-14","Court2","Center3","CityA",@a);/*Center_id not in that city*//*1405*/
call getCourtBooking("2020-02-14","Court2","Center2","CityD",@a);/*City NOT exist*//*1404*/


/*Get Player Booking*/
call getPlayerBookings("2020-02-12","!@$","CityB",@a);/*invalid player_id*//*1502*/
call getPlayerBookings("2020-02-12","Player1","1@#",@a);/*invalid player_id*//*1501*/
call getPlayerBookings("2020-02-12","Player5","CityB",@a);/*Player not exist*//*1504*/
call getPlayerBookings("2020-02-12","Player1","CityB",@a);/*Booking not exist*//*1505*/
call getPlayerBookings("2020-02-12","Player1","CityD",@a);/*city not exist*//*1503*/
call getPlayerBookings("2020-05-12","Player2","CityA",@a);/*Success*//*1500*/
