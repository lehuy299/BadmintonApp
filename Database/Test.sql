/*Create City*/
call createCity("CityA",@a);/*success*//*100*/
call createCity("CityB",@a);/*sucess*//*100*/
call createCity("CityC",@a);/*success*//*100*/
call createCity("CityA",@a);/*city existed*//*102*/
call createCity("!@#",@a);/*Invalid city_id*//*101*/

/*Create Center*/
call createCityCenter("CityB","Center2",@a);/*Success*//*200*/
call createCityCenter("CityA","Center3",@a);/*Success*/ /*200*/
call createCityCenter("CityA","Center3",@a);/*Center existed*//*204*/
call createCityCenter("@$%","Center3",@a);/*Invaild city_id*//*201*/
call createCityCenter("CityA","!@#",@a);/*Invaild center_id*//*202*/
call createCityCenter("CityD","Center3",@a);/*City not existed*//*203*/

/*Create Court*/
call createCityCenterCourt("!@$","CityA","Center3",@a);/*Invalid court_id*//*303*/
call createCityCenterCourt("Court2","!@$","Center3",@a);/*Invalid city_id*//*301*/
call createCityCenterCourt("Court2","CityA","!@%",@a);/*Invalid center_id*//*302*/
call createCityCenterCourt("Court2","CityA","Center3",@a);/*Success*//*300*/
call createCityCenterCourt("Court2","CityA","Center3",@a);/* Court existed*//*306*/
call createCityCenterCourt("Court2","CityD","Center3",@a);/*City not existed*//*304*/
call createCityCenterCourt("Court2","CityA","Center2",@a);/*Center not in that city*//*305*/

/*Create PLayer*/
call createPlayer("!@$!@","Huong","huongnguyenquynh2210@gmail.com",@a);/*Invalid player_id*//*401*/
call createPlayer("Player5","  ","huongnguyenquynh2210@gmail.com",@a);/*Invalid player name*//*402*/
call createPlayer("Player5","124  ","huongnguyenquynh2210@gmail.com",@a);/*Invalid player name*//*402*/
call createPlayer("Player2","Huong","@sdaf ",@a);/*Invalid player_email*//*403*/
call createPlayer("Player2","Nguyen","huongnguyenquynh2210@gmail.com",@a);/*Success*//*400*/
call createPlayer("Player1","Nguyen Quynh Huong","huongnguyenquynh2210@gmail.com",@a);/*Success*//*400*/
call createPlayer("Player1","Nguyen Quynh Huong","huongnguyenquynh2210@gmail.com",@a);/*Player existed*//*404*/
call createPlayer("Player3","Quynh","huongnguyenquynh2210@gmail.com",@a);/*Success*//*400*/
/*Create Staff*/
call createStaff("12$","CityA","Center3",@a);/*Invalid staff_id*//*503*/
call createStaff("Staff1","!$!","Center3",@a);/*Invalid city_id*//*501*/
call createStaff("Staff1","CityA","!@$",@a);/*Invalid center_id*//*502*/
call createStaff("Staff1","CityA","Center3",@a);/*Success*//*500*/
call createStaff("Staff1","CityA","Center3",@a);/*Staff existed*//*506*/
call createStaff("Staff1","CityA","Center2",@a);/*Center not in that city*//*505*/
call createStaff("Staff1","CityD","Center2",@a);/*City NOT exist*//*504*/
/*Create Booking*/
/*Existed : "Booking1","2020-02-12","7:00:00","8:00:00","Court2","Center3","CityA","Player1",unpaid*/
insert into booking(date,startTime,endTime,court,center,city,player,timestamp) values ("2020-02-12","7:00:00","8:00:00","Court2","Center3","CityA","Player1",now());
CALL createBooking("2020-05-10","12:30:00","14:00:00","!@$","Center3","Court2","Player2",@a);/*Invalid city_id*//*601*/
CALL createBooking("2020-05-10","12:30:00","14:00:00","CityA","!@$","Court2","Player2",@a);/*Invalid center_id*//*602*/
CALL createBooking("2020-05-10","12:30:00","14:00:00","CityA","Center3","%!@#%","Player2",@a);/*Invalid court_id*//*603*/
CALL createBooking("2020-05-10","12:30:00","14:00:00","CityA","Center3","Court2","1@%#",@a);/*Invalid player_id*//*604*/
CALL createBooking("2020-05-12","7:00:00","8:00:00","CityA","Center3","Court2","Player2",@a);/*Success*//*600*/
CALL createBooking("2020-05-12","11:30:00","12:15:00","CityA","Center3","Court2","Player2",@a);/*Success*//*600*/
CALL createBooking("2020-05-12","12:30:00","13:30:00","CityA","Center3","Court2","Player2",@a);/*Success*//*600*/
CALL createBooking("2020-05-12","12:30:00","14:00:00","CityA","Center3","Court2","Player5",@a);/*Player not exist*//*605*/
CALL createBooking("2020-05-12","12:30:00","14:00:00","CityD","Center3","Court2","Player1",@a);/*City not exist*//*606*/
CALL createBooking("2020-05-12","12:30:00","14:00:00","CityA","Center2","Court2","Player2",@a);/*Center not exist in that city*//*607*/
CALL createBooking("2020-05-12","12:30:00","14:00:00","CityA","Center3","Court3","Player2",@a);/*Court not exist in that center*//*608*/
CALL createBooking("2020-01-09","7:30:00","9:00:00","CityA","Center3","Court2","Player2",@a);/*start time in the past*//*609*/
CALL createBooking("2020-05-12","6:30:00","8:00:00","CityA","Center3","Court2","Player2",@a);/*Start time before opening time*//*610*/
CALL createBooking("2020-05-12","20:30:00","22:00:00","CityA","Center3","Court2","Player2",@a);/*End time after closing time*//*611*/
CALL createBooking("2020-05-12","12:30:00","10:00:00","CityA","Center3","Court2","Player2",@a);/*End time before start time*//*612*/
CALL createBooking("2020-05-12","7:30:00","10:00:00","CityA","Center3","Court2","Player2",@a);/*Booking time must be 45/60/75/90 minutes*//*613*/
CALL createBooking("2020-05-12","7:30:00","8:00:00","CityA","Center3","Court2","Player2",@a);/*Booking time must be 45/60/75/90 minutes*//*613*/
CALL createBooking("2020-05-12","7:00:00","8:20:00","CityA","Center3","Court2","Player2",@a);/*Booking time must be 45/60/75/90 minutes*//*613*/
CALL createBooking("2020-05-12","7:15:00","8:00:00","CityA","Center3","Court2","Player3",@a);/*Overlap booking*//*614*/
CALL createBooking("2020-05-12","11:00:00","12:15:00","CityA","Center3","Court2","Player3",@a);/*Overlap booking*//*614*/
CALL createBooking("2020-05-12","10:45:00","12:15:00","CityA","Center3","Court2","Player3",@a);/*Overlap booking*//*614*/
CALL createBooking("2020-05-17","11:30:00","13:00:00","CityA","Center3","Court2","Player2",@a);/*More than 3 bookings*//*615*/
CALL createBooking("2020-05-15","11:30:00","13:00:00","CityA","Center3","Court2","Player1",@a);/*Pending booking in the past*//*616*/
CALL createBooking("2020-04-22","7:30:00","8:30:00","CityA","Center3","Court2","Player3",@a);/*Success*/
/*Cancel Booking */
call cancelBooking(1,"#$$",@a);/*Invalid player_id*//*701*/
call cancelBooking(2,"Player2",@a);/*Success*//*700*/
call cancelBooking(2,"Player2",@a);/*Booking not existed*//*702*/
call cancelBooking(7,"Player2",@a);/*Booking not existed*//*702*/
call cancelBooking(1,"Player5",@a);/*player not existed*//*703*/
call cancelBooking(1,"Player2",@a);/*Booking NOT belong to Player*//*704*/
call cancelBooking(5,"Player3",@a);/*less than 24h from start time *//*705*/

/*UpdateBookingStatus*/

call updateBookingStatus(1,1,"!@!@#","Center3","Staff1",@a);/*Invalid city_id*//*801*/
call updateBookingStatus(1,1,"CityA","#!$","Staff1",@a);/*Invalid center_id*//*802*/
call updateBookingStatus(1,1,"CityA","Center3","!@$!@$",@a);/*Invalid staff_id*//*803*/
call updateBookingStatus(1,1,"CityA","Center3","Staff1",@a);/*Success*//*800*/
call updateBookingStatus(7,1,"CityA","Center3","Staff1",@a);/*Booking_id not exist*//*804*/
call updateBookingStatus(1,1,"CityD","Center3","Staff1",@a);/*City_id not exist*//*805*/
call updateBookingStatus(1,1,"CityA","Center2","Staff1",@a);/*Center_id not exist in that city*//*806*/
call updateBookingStatus(1,1,"CityB","Center2","Staff1",@a);/*Booking NOT belong to center*//*807*/
call updateBookingStatus(1,1,"CityA","Center3","Staff4",@a);/*Staff id NOT exists *//*808*/

/*Get all cities*/
call getAllCities(@a);/*Success*//*900*/

/*Get all center in that city*/
call getAllCitiesCenters("!@$",@a);/*Invalid city_id*//*1001*/
call getAllCitiesCenters("CityB",@a);/*Success*//*1000*/
call getAllCitiesCenters("CityC",@a);/*No center in that city*//*1002*/

/*Get all court in that center*/
call getAllCitiesCentersCourts("1@#!@","Center3",@a);/*Invalid city_id*//*1101*/
call getAllCitiesCentersCourts("CityA","4!@$",@a);/*Invalid center_id*//*1102*/
call getAllCitiesCentersCourts("CityA","Center3",@a);/*Success*//*1100*/
call getAllCitiesCentersCourts("CityC","Center3",@a);/*Center_id not exist in that city*//*1104*/
call getAllCitiesCentersCourts("CityB","Center2",@a);/*No court in that center*//*1105*/

/*Get all players*/
call getAllPlayers(@a);

/*Get Booking Info*/
call getBookingInfo(1,@a);/*Success*//*1300*/
call getBookingInfo(6,@a);/*Booking_id not existed*//*1301*/

/*Get Center Booking*/
call getCenterBooking("2020-05-14","!@#%","CityA",@a);/*Invalid center_id*//*1402*/
call getCenterBooking("2020-05-14","Center3","$#",@a);/*Invalid city_id*//*1401*/
call getCenterBooking("2020-05-12","Center3","CityA",@a);/*Success*//*1400*/
call getCenterBooking("2020-02-14","Center3","CityA",@a);/*No booking on that date at the center*//*1405*/
call getCenterBooking("2020-02-14","Center2","CityA",@a);/*Center_id not in that city*//*1404*/
call getCenterBooking("2020-02-14","Center2","CityD",@a);/*City NOT exist*//*1403*/

/*Get Center Booking*/
call getCourtBooking("2020-05-14","Court2","!@#%","CityA",@a);/*Invalid center_id*//*1402*/
call getCourtBooking("2020-05-14","Court2","Center3","$#",@a);/*Invalid city_id*//*1401*/
call getCourtBooking("2020-05-14","&Court2","Center3","CityA",@a);/*Invalid city_id*//*1401*/
call getCourtBooking("2020-05-12","Court2","Center3","CityA",@a);/*Success*//*1400*/
call getCourtBooking("2020-02-14","Court2","Center3","CityA",@a);/*No booking on that date at the center*//*1405*/
call getCourtBooking("2020-02-14","Court2","Center2","CityA",@a);/*Center_id not in that city*//*1404*/
call getCourtBooking("2020-02-14","Court2","Center2","CityD",@a);/*City NOT exist*//*1403*/
call getCourtBooking("2020-05-14","Court4","Center3","CityA",@a);/*Court not in that center*//*1400*/

/*Get Player Booking*/
call getPlayerBookings("2020-02-12","!@$","CityB",@a);/*invalid player_id*//*1502*/
call getPlayerBookings("2020-02-12","Player1","1@#",@a);/*invalid player_id*//*1501*/
call getPlayerBookings("2020-02-12","Player5","CityB",@a);/*Player not exist*//*1504*/
call getPlayerBookings("2020-02-12","Player1","CityB",@a);/*Booking not exist*//*1505*/
call getPlayerBookings("2020-02-12","Player1","CityD",@a);/*city not exist*//*1503*/
call getPlayerBookings("2020-02-12","Player1","CityA",@a);/*Success*//*1500*/
