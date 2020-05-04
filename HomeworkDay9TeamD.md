# Day 9

### Homework Team D

### _Kind of information that the Facebook API is needed for uniquely indentifying players:_
* __Facebook ID.__
* __Phone number.__
* __Address.__
* __Day of Birth.__
* __(The information from the players' Facebook profiles)__
  

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
    * __Solution:We will use Timer.When the players are not using this app for an amount of time,then the Timer will log out the Facebook account from the app automatically.__
* __When login by  using Facebook is not an option__:  
    * __Solution:We will suggest the players to link the Facebook account with the normal account so that when the players can login the same account either using Facebook or normal account.__
