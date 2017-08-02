# Description
#   A hubot script that will connect to the Felicity Service Desk - Integration Platform
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   config  - Sets the base URL>
#   get ticket details - Gets the Ticket Details for which values are set>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Abhishek Kulkarni - Unotech Software

#Variables defined for constants
Conversation = require('hubot-conversation')
linktoAPI = 'nph-genericinterface.pl/Webservice/GetTicketDetails/TicketGet?TicketID='
paramUL='&UserLogin='
paramPWD='&Password='
configOptions = ["1","2","3","4"]
choiceStrg = undefined
choice = undefined
msgValStrg = undefined
bodyValStrg = undefined
#End of constant definition

#Internal Functions_

# Function setConfiguration

setConfiguration = (msg2,robot,configStrg,dialog_conf) ->
  msg2.send "Your "+configStrg+" is "+robot.brain.get(configStrg)
  msg2.send "Please say set <"+configStrg+"> to set your "+configStrg
  dialog_conf.addChoice /set (.*)/i, (msg3) ->
    baseurlvar = msg3.match[1]
    robot.brain.set(configStrg,baseurlvar)
    msg3.send "You set your "+configStrg+" as "+baseurlvar
    return
  return

# Function: checkConfiguration

checkConfiguration = (robot,msg) ->
  returnVal = true
  ret = undefined
  callString = JSON.stringify(robot.brain.get("baseurl")).slice(1,-1)+linktoAPI+JSON.stringify(robot.brain.get("ticketID")).slice(1,-1)+paramUL+JSON.stringify(robot.brain.get("userLogin")).slice(1,-1)+paramPWD+JSON.stringify(robot.brain.get("userPWD")).slice(1,-1)
  robot.http(callString).get() (err,msg1,body) ->
    bodyValStrg = body
    msgValStrg = msg1
    if body == null
      returnVal = false
    if body != null && msg1.statusCode isnt 200
      returnVal = false
    if returnVal == true
      ret = checkAuthentication(robot)
    else
      ret = "Configuration Failed"
    #return ""+ret
    msg.reply ret   

# Function: checkAuthentication

checkAuthentication = (robot,msg) ->
  returnVal = true
  ret = undefined
  if bodyValStrg.indexOf('AuthFail') >= 0
    returnVal = false  
  if returnVal == true
    ret = checkAuthorization(robot)
  else
    ret = "Authentication Failed"
  return ret

# Function checkAuthorization

checkAuthorization = (robot,msg) ->
  returnVal = true
  ret = undefined
  if bodyValStrg.indexOf('AccessDenied') >= 0 
    returnVal = false
  if returnVal == true
    ret = getTicketDetails(robot,msg)
  else
    ret = "Authorization Failed"
  return ret
  

# Function getTicketDetails

getTicketDetails = (robot,msg) ->
  return "Request Successful"+bodyValStrg

#End of Internal Function Definitions

module.exports = (robot) ->
  switchConfig = new Conversation(robot)
  robot.hear /.*?((c|C)onfi(g|gure|guration))/, (msg)->

    dialog_conf = switchConfig.startDialog(msg)
    msg.send "Starting Configuration..\n 1. Base URL \n 2. User Name\n 3. Password\n 4. TicketID"
 
#Adds a choice to change base URL
   
    dialog_conf.addChoice /1/i, (msg2) ->
      setConfiguration(msg2,robot,"baseurl",dialog_conf)
      return

#Adds a choice to change user login
  
    dialog_conf.addChoice /2/i, (msg2) ->
      setConfiguration(msg2,robot,"userLogin",dialog_conf)
      return

#Adds a choice to change password

    dialog_conf.addChoice /3/i, (msg2) ->
      msg2.send "Your Password is "+robot.brain.get("userPWD")
      msg2.send "Please say set <password>> to set your password"
      dialog_conf.addChoice /set (.*)/i, (msg3) ->
        userLoginvar = msg3.match[1]
        robot.brain.set("userPWD",userLoginvar)
        msg3.send "You set your Password as "+userLoginvar
        return
      return

#Adds a choice to change Ticket ID

    dialog_conf.addChoice /4/i, (msg2) ->
      setConfiguration(msg2,robot,"ticketID",dialog_conf)
      return
    return


#Function to get ticket details


  robot.hear /.&?(ticket details)/, (msg)->
    checkConfiguration(robot,msg)
