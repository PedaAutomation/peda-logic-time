timeInfo = require './time.coffee'

german = require './i18n/de.json'
english = require './i18n/en.json'

defaultPlace = process.env.DEFAULT_TIME_PLACE

timeHere = (data, slave) -> 
  output = timeInfo.getTimeIn defaultPlace, slave, (output) ->
    slave.sendOutputToCapability(output, "tts")

time = (data, slave) ->
  command = data.capability.split(":")[1]
  input = data.command
  regex = slave.__regex(command)
  output = timeInfo.getTimeIn regex.exec(input)[1], slave, (output) ->
    slave.sendOutputToCapability(output, "tts")
  

module.exports = (slave) ->

  slave.setType "logic"
  slave.setName "time"
  
  slave.registerLanguage "en", english, true
  slave.registerLanguage "de", german

  slave.registerLogic "time", slave.__("time"), time
  slave.registerLogic "timeHere", slave.__("timeHere"), timeHere
  


 
  
    
       
