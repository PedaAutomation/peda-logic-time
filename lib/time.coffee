request = require 'request'
timezoner = require 'timezoner'
tz = require 'timezone/loaded'


getCoordinatesFromPlace = (place, cb) ->  
  url = "http://maps.google.com/maps/api/geocode/json?address=#{encodeURIComponent(place)}&sensor=false"
  request {url: url, json: true}, (err, response, body) ->   
    cb body.results[0].geometry.location

getTimeZone = (place, cb) ->
  getCoordinatesFromPlace place, (location) ->
    timezoner.getTimeZone location.lat, location.lng, (err, data) ->      
      if err then console.log err
      else 
        cb data.timeZoneId

getTimeIn = (place, helper, cb) ->
  getTimeZone place, (zoneId) ->
    now = new Date()    
    utc = tz(now)    
    temp = tz utc, '%c', helper.__("locale"), zoneId 
    temp = temp.split now.getFullYear() #crazy things happen if the year is x and in the destination timezone x+1 (if it's silvester/new year)  
    temp = temp[1].split ":"
    zero = temp[0].indexOf("0")
    if zero isnt -1
      temp[0] = temp[0].substring zero+1, zero+2
    result = helper.__("outputFormat").replace("%h", temp[0]).replace("%m", temp[1])
    cb result

module.exports.getTimeIn = getTimeIn
