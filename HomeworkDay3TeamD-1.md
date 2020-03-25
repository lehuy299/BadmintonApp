# Day 3
## Review Day 2
- [ ] Interfaces: client-server communication; stateless protocol
- [ ] [Git: workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)

## Presentations: Homework #2.1
## Presentations: Homework #2.1: _Design/describe interfaces [client-server] Presentation-Logic_

## Discussion: Homework #2.1: _Design/describe interfaces [client-server] Presentation-Logic_

### Notes
* unique identifiers known/agreed upon by presentation/client and 
logic/server: cityId, venueId, courtId, userId/playerId, bookingId, statusId.
* success/errorCode known/agreed upon by client and server
* ordering (if any), when response is a list/array, known/agreed upon by client and server
* structure (if any), when response contains (potentially) structured data,
known/agreed upon by client and server
### _getAvailableSlots_
* __Description__: request a City, a date, hand out all available slots.
* __security/caller__: Badminton Player
* __request__: getASlots(City, date)
* __response__: 
  * __success__: if the request is approved -> SuccessCode + cityname, array of (centralID, venueSlots), where venueSlots is an array of (venueID, courtSlots), where courseSlots is an array of (courseID, Slots), where Slots is an array of (Start hour, End hour)
  * __error__: if fail
	 the server will send back malformed request syntax, where this error occurs when the player enters city name and date in a wrong format 
	 there is no array of info appear in the screen -> missing request-> can’t get available slot form the storage.

### _createBooking_
* __Description__: for a given day, court, start-end hour, player info, making a booking
* __security/caller__: Badminton Player
* __request__: createBooking(playerID, court, date, start, end)
* __response__: 
  * __success__: SuccessCode + Booking Successful
  * __error__:  if fail
	 the available time full so that the booking is rejected
	504 Gateway Timeout + where the booking of the person X haven’t been response in time by the server as there is request form another client.

### _cancelBooking_
* __Description__: for a given bookingID, cancel that booking
get all the bookings:
* __security/caller__: Badminton Player
* __request__: cancelBooking(bookingID)
* __response__: 
  * __success__: SuccessCode + Cancel Successful
  * __error__:if fail 
	 the cancelBooking is rejected because the player cancels after the deadline (before 24h of the starting-time).

### _getPlayerBooking_
* __Description__: for a given playerID, date and city, view all the bookings for that day
* __security/caller__: Badminton Players/Staff
* __request__: getPlayerBooking(playerID, date, city)
* __response__: 
  * __success__: SuccessCode + array of (centreId, venueBookings), where venueBookings is an array of (venueID, courtBookings), where courtBookings is an array of (courtID, bookings), where bookings is an array of (Start hour, End hour)
  * __error__:  if fail
	 when the staff or player request to retrieve all booking at that day, the screen will pop up a message DNS Server isn’t responding

### _getVenueBooking_
* __Description__: : for a given venueID and date, get all the bookings of that venue
* __security/caller__: Staff
* __request__: getVenueBooking(venueID, date)
* __response__: 
  * __success__: SuccessCode + array of (courtId, bookings), where bookings is an array of (startHour, endHour)
  * __error__: if fail
	504 Gateway Timeout + where the staff X wait for a response form server but another staff Y also request to the server through app or browser.

### _getBookingInfo_
* __Description__: for a given bookingID, get all the booking info
* __security/caller__: Staff
* __request__: getBookingInfo(bookingID)
* __response__: 
  * __success__: SuccessCode
  * __error__: if fail
	504 Gateway Timeout + where the staff X wait for a response form server but another staff Y also request to the server through app or browser.

### _updateBookingPaymentStatus_
* __Description__: for a given bookingId, update the booking's 
payment status
* __security/caller__: Staff
* __request__: updateBookingPaymentStatus(bookingID, statusID)
* __response__: 
  * __success__: SuccessCode + status has been updated
  * __error__: if fail
	When the staff X click update for that booking, server response Conflict and the status is remained
	Too many requests form staff X that the server can’t afford all at the time

### _getNameCity_/_getNameVenue_/_getNameCourt_/_getNamePlayer_
* Description: for a given cityId/venueId/courtId/userId, get the corresponding name (to display)
* security/caller: Staff, Badminton Player
* request: getNameCity(cityID), getNameVenue(venueID), getNameCourt(courtID), getNamePlayer(playerID)
* response: 
  * success: SuccessCode + name of the city/venue/court/player
  * error: if fail
	the server will send back malformed request syntax, where this error occurs when the player enters city name and date in a wrong format.
	504 Gateway Timeout + when there is too much request pending to response and lots of request are going to be made.

## Homework #3
- [ ] Test cases/scenarios [+ errors]: interfaces Presentation-Logic
- [ ] Review/Update (if needed) design/describe interfaces [client-server] 
Logic-Data 
- [ ] Review/Update (if needed) design database (Entity-Relationship Diagram)
- [ ] Review/Update (if needed) design UI (Activity diagram + mockups)