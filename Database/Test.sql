/*Create City*/
call createCity("CityA",@a);/*success*/
call createCity("CityB",@a);/*sucess*/
call createCity("CityC",@a);/*success*/
call createCity("CityA",@a);/*city existed*/
call createCity("!@#",@a);/*Invalid city_id*/

/*Create Center*/
call createCityCenter("CityB","Center2",@a);/*Success*/ 
call createCityCenter("CityA","Center3",@a);/*Success*/ 
call createCityCenter("CityA","Center3",@a);/*Center existed*/
call createCityCenter("@$%","Center3",@a);/*Invaild city_id*/
call createCityCenter("CityA","!@#",@a);/*Invaild center_id*/
call createCityCenter("CityD","Center3",@a);/*City not existed*/

/*Create Court*/
call createCityCenterCourt("!@$","CityA","Center3",@a);/*Invalid court_id*/
call createCityCenterCourt("Court2","!@$","Center3",@a);/*Invalid city_id*/
call createCityCenterCourt("Court2","CityA","!@%",@a);/*Invalid center_id*/
call createCityCenterCourt("Court2","CityA","Center3",@a);/*Success*/
call createCityCenterCourt("Court2","CityA","Center3",@a);/* Court existed*/
call createCityCenterCourt("Court2","CityD","Center3",@a);/*City not existed*/
call createCityCenterCourt("Court2","CityA","Center2",@a);/*Center not in that city*/

/*Create PLayer*/
call createPlayer("!@$!@",@a);/*Invalid player_id*/
call createPlayer("Player1",@a);/*Success*/
call createPlayer("Player2",@a);/*Success*/
call createPlayer("Player1",@a);/*Player existed*/

/*Create Staff*/
call createStaff("12$","CityA","Center3",@a);/*Invalid staff_id*/
call createStaff("Staff1","!$!","Center3",@a);/*Invalid city_id*/
call createStaff("Staff1","CityA","!@$",@a);/*Invalid center_id*/
call createStaff("Staff1","CityA","Center3",@a);/*Success*/
call createStaff("Staff1","CityA","Center3",@a);/*Staff existed*/
call createStaff("Staff1","CityA","Center2",@a);/*Center not in that city*/

/*Create Booking*/
/*Existed : "Booking1","2020-02-12","7:00:00","8:00:00","Court2","Center3","CityA","Player1",unpaid*/
insert into booking values ("Booking1","2020-02-12","7:00:00","8:00:00","Court2","Center3","CityA","Player1",0,now());
CALL createBooking("!@$!4","2020-05-10","12:30:00","14:00:00","CityA","Center3","Court2","Player2",@a);/*Invalid booking_id*/
CALL createBooking("Booking2","2020-05-10","12:30:00","14:00:00","!@$","Center3","Court2","Player2",@a);/*Invalid city_id*/
CALL createBooking("Booking2","2020-05-10","12:30:00","14:00:00","CityA","!@$","Court2","Player2",@a);/*Invalid center_id*/
CALL createBooking("Booking2","2020-05-10","12:30:00","14:00:00","CityA","Center3","%!@#%","Player2",@a);/*Invalid court_id*/
CALL createBooking("Booking2","2020-05-10","12:30:00","14:00:00","CityA","Center3","Court2","1@%#",@a);/*Invalid player_id*/
CALL createBooking("Booking2","2020-05-10","12:30:00","14:00:00","CityA","Center3","Court2","Player2",@a);/*Success*/
CALL createBooking("Booking3","2020-05-14","12:30:00","14:00:00","CityA","Center3","Court2","Player2",@a);/*Success*/
CALL createBooking("Booking4","2020-04-13","7:30:00","9:00:00","CityA","Center3","Court2","Player2",@a);/*Success*/
CALL createBooking("Booking2","2020-05-12","12:30:00","14:00:00","CityA","Center3","Court2","Player2",@a);/*Booking_id existed*/
CALL createBooking("Booking5","2020-05-12","12:30:00","14:00:00","CityA","Center3","Court2","Player5",@a);/*Player not exist*/
CALL createBooking("Booking5","2020-05-12","12:30:00","14:00:00","CityD","Center3","Court2","Player1",@a);/*City not exist*/
CALL createBooking("Booking5","2020-05-12","12:30:00","14:00:00","CityA","Center2","Court2","Player2",@a);/*Center not exist in that city*/
CALL createBooking("Booking5","2020-05-12","12:30:00","14:00:00","CityA","Center3","Court3","Player2",@a);/*Court not exist in that center*/
CALL createBooking("Booking5","2020-01-09","7:30:00","9:00:00","CityA","Center3","Court2","Player2",@a);/*start time in the past*/
CALL createBooking("Booking5","2020-05-12","6:30:00","8:00:00","CityA","Center3","Court2","Player2",@a);/*Start time before opening time*/
CALL createBooking("Booking5","2020-05-12","20:30:00","22:00:00","CityA","Center3","Court2","Player2",@a);/*End time after closing time*/
CALL createBooking("Booking5","2020-05-12","12:30:00","10:00:00","CityA","Center3","Court2","Player2",@a);/*End time before start time*/
CALL createBooking("Booking5","2020-05-12","7:30:00","10:00:00","CityA","Center3","Court2","Player2",@a);/*Booking time must be 45/60/75/90 minutes*/
CALL createBooking("Booking5","2020-05-12","7:30:00","8:00:00","CityA","Center3","Court2","Player2",@a);/*Booking time must be 45/60/75/90 minutes*/
CALL createBooking("Booking5","2020-05-12","7:00:00","8:20:00","CityA","Center3","Court2","Player2",@a);/*Booking time must be 45/60/75/90 minutes*/
CALL createBooking("Booking5","2020-05-10","11:30:00","13:00:00","CityA","Center3","Court2","Player1",@a);/*Overlap booking*/
CALL createBooking("Booking5","2020-05-10","12:45:00","14:15:00","CityA","Center3","Court2","Player1",@a);/*Overlap booking*/
CALL createBooking("Booking5","2020-05-10","12:30:00","13:30:00","CityA","Center3","Court2","Player1",@a);/*Overlap booking*/
CALL createBooking("Booking5","2020-05-17","11:30:00","13:00:00","CityA","Center3","Court2","Player2",@a);/*More than 3 bookings*/
CALL createBooking("Booking5","2020-05-15","11:30:00","13:00:00","CityA","Center3","Court2","Player1",@a);/*Pending booking in the past*/
 
/*Cancel Booking */
call cancelBooking("!@#","Player2",@a);/*Invalid booking_id*/
call cancelBooking("Booking2","#$$",@a);/*Invalid player_id*/
call cancelBooking("Booking2","Player2",@a);/*Success*/
call cancelBooking("Booking2","Player2",@a);/*Booking not existed*/
call cancelBooking("Booking7","Player2",@a);/*Booking not existed*/
call cancelBooking("Booking1","Player5",@a);/*player not existed*/
call cancelBooking("Booking1","Player2",@a);/*Booking NOT belong to Player*/
call cancelBooking("Booking4","Player2",@a);/*less than 24h from start time */

/*UpdateBookingStatus*/
call updateBookingStatus("!@#$",1,"CityA","Center3","Staff1",@a);/*Invalid booking_id*/
call updateBookingStatus("Booking1",1,"!@!@#","Center3","Staff1",@a);/*Invalid city_id*/
call updateBookingStatus("Booking1",1,"CityA","#!$","Staff1",@a);/*Invalid center_id*/
call updateBookingStatus("Booking1",1,"CityA","Center3","!@$!@$",@a);/*Invalid staff_id*/
call updateBookingStatus("Booking1",1,"CityA","Center3","Staff1",@a);/*Success*/
call updateBookingStatus("Booking7",1,"CityA","Center3","Staff1",@a);/*Booking_id not exist*/
call updateBookingStatus("Booking1",1,"CityD","Center3","Staff1",@a);/*City_id not exist*/
call updateBookingStatus("Booking1",1,"CityA","Center2","Staff1",@a);/*Center_id not exist in that city*/
call updateBookingStatus("Booking1",1,"CityB","Center2","Staff1",@a);/*Booking NOT belong to center*/
call updateBookingStatus("Booking1",1,"CityA","Center3","Staff4",@a);/*Staff id NOT exists */

/*Get all cities*/
call getAllCities(@a);/*Success*/

/*Get all center in that city*/
call getAllCitiesCenters("!@$",@a);/*Invalid city_id*/
call getAllCitiesCenters("CityB",@a);/*Success*/
call getAllCitiesCenters("CityC",@a);/*No center in that city*/

/*Get all court in that center*/
call getAllCitiesCentersCourts("1@#!@","Center3",@a);/*Invalid city_id*/
call getAllCitiesCentersCourts("CityA","4!@$",@a);/*Invalid center_id*/
call getAllCitiesCentersCourts("CityA","Center3",@a);/*Success*/
call getAllCitiesCentersCourts("CityC","Center3",@a);/*Center_id not exist in that city*/
call getAllCitiesCentersCourts("CityB","Center2",@a);/*No court in that center*/

/*Get all players*/
call getAllPlayers(@a);

/*Get Booking Info*/
call getBookingInfo("!@#$",@a);/*Invalid booking_id*/
call getBookingInfo("Booking1",@a);/*Success*/
call getBookingInfo("Booking2",@a);/*Booking_id not existed*/

/*Get Center Booking*/
call getCenterBooking("2020-05-14","!@#%","CityA",@a);/*Invalid center_id*/
call getCenterBooking("2020-05-14","Center3","$#",@a);/*Invalid city_id*/
call getCenterBooking("2020-05-14","Center3","CityA",@a);/*Success*/
call getCenterBooking("2020-02-14","Center3","CityA",@a);/*No booking on that date at the center*/
call getCenterBooking("2020-02-14","Center2","CityA",@a);/*Center_id not in that city*/

/*Get Player Booking*/
call getPlayerBookings("2020-02-12","!@$","CityB",@a);/*invalid player_id*/
call getPlayerBookings("2020-02-12","Player1","1@#",@a);/*invalid player_id*/
call getPlayerBookings("2020-02-12","Player5","CityB",@a);/*Player not exist*/
call getPlayerBookings("2020-02-12","Player1","CityB",@a);/*Booking not exist*/
call getPlayerBookings("2020-02-12","Player1","CityA",@a)/*Success*/
