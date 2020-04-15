# Day 9

### Homework Team D

### _Kind of information that the Facebook API is needed for indentifying uniquely players:_
* __Facebook ID.__
* __Phone number.__
* __Address.__
* __Day of Birth.__
  

### _Advantage and Disadvantage of Facebook Login_
### _Advantage_
* __Easy to use.__
* __If the users forgot about password,this is a good choice for them to login.__ 
* __It won't take so much time to login.__
### _Disadvantage_
* __Data accurracy(the player can't fully trust about facebook login).__
*  __Easy to be hacked by someone.__
*  __Not everyone is on Facebook.__


### _The risk and how to mitigate_
* __When the players login by Facebook,the token is not expired__: 
    * __Solution:We will use Clock.When the players are not on this app for a long time,then the Clock will make the Facebook log out automatically.__
* __Someone will use the bad purposes to hack the players'Facebook accounts__:  
    * __Solution:If the players can't login by Facebook,they should login by another ways such as traditional login,login by Google account.__
