call createCity ("CityA",@a);
call createCityCenter("CityA","Center1",45,@a);
call createCityCenter("CityA","Center2",60,@a);
call createCityCenterCourt("Court1","CityA","Center1",@a);
call createCityCenterCourt("Court1","CityA","Center2",@a);
insert into opening_times (center,city,week_day,openHour,closeHour) values ("Center1","CityA","Monday",maketime(7,0,0),maketime(21,0,0)), ("Center1","CityA","Tuesday",maketime(7,0,0),maketime(21,0,0)),
("Center1","CityA","Wednesday",maketime(7,0,0),maketime(21,0,0)),("Center1","CityA","Thursday",maketime(7,0,0),maketime(21,0,0)),
("Center1","CityA","Friday",maketime(7,0,0),maketime(21,0,0)),("Center1","CityA","Saturday",maketime(9,0,0),maketime(23,0,0)),
("Center1","CityA","Sunday",maketime(9,0,0),maketime(23,0,0));
insert into opening_times (center,city,week_day,openHour,closeHour) values ("Center2","CityA","Monday",maketime(7,0,0),maketime(21,0,0)), ("Center2","CityA","Tuesday",maketime(7,0,0),maketime(21,0,0)),
("Center2","CityA","Wednesday",maketime(7,0,0),maketime(21,0,0)),("Center2","CityA","Thursday",maketime(7,0,0),maketime(21,0,0)),
("Center2","CityA","Friday",maketime(7,0,0),maketime(21,0,0)),("Center2","CityA","Saturday",maketime(9,0,0),maketime(23,0,0)),
("Center2","CityA","Sunday",maketime(9,0,0),maketime(23,0,0));
insert into holidays values ("CityA",str_to_date("30-04", '%d-%m')),("CityA",str_to_date("01-05", '%d-%m')),("CityA",str_to_date("02-09", '%d-%m'));
call createPlayer("Player1","Huong","huongnguyen@gmail.com",@a);
call createBooking("2020-05-02","7:00:00","8:00:00","CityA","Center1","Court1","Player1",@a);/*start time before opening time*/
call createBooking("2020-05-05","21:00:00","22:00:00","CityA","Center1","Court1","Player1",@a);/*end time after closing time*/
call createBooking("2020-05-01","7:00:00","8:00:00","CityA","Center2","Court1","Player1",@a);/*Holiday*/
call createBooking("2020-05-05","7:00:00","7:45:00","CityA","Center2","Court1","Player1",@a);/*Booking not satisfied length*/

