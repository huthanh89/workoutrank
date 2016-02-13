#--------------------------------------------------
# Imports
#--------------------------------------------------

async    = require 'async'
mongoose = require 'mongoose'

#--------------------------------------------------
# List
#--------------------------------------------------

module.list = (req, res, next) ->

  async.waterfall [

    (callback) ->


      #inspect = require('eyespect').inspector()
      #request = require 'request'


      ###
      options =
        method: 'POST'
        url:'https://api.twitter.com/oauth2/token'
        headers:
          Authorization: 'Basic RmRFM09JRXpQdHRVOUR3M0pmOHhwQXFQVzp1Y1pHbEVPYURGOEs3TUlyWXd6MDRiaU9ENUpUaGJXazNrVnZ3Rml4Q25kS0EyVXBnbw=='
        form:
          'grant_type': 'client_credentials'
        json: true

      request options, (err, res, body) ->
        inspect err, 'err'
        inspect res, 'res'
        inspect body, 'body'
        return


      Twitter = require 'twitter'
      inspect = require('eyespect').inspector()

      client = new Twitter
        consumer_key: 'FdE3OIEzPttU9Dw3Jf8xpAqPW'
        consumer_secret: 'ucZGlEOaDF8K7MIrYwz04biOD5JThbWk3kVvwFixCndKA2Upgo'
        access_token_key: '2378524963-kn57V0iYZNwYnWjxvHussYMDC5ynbDdDq45VFwX'
        access_token_secret: 'y6ZnDJSc7HSpUVMQZsmg13RPp9Fzkt5gwlCQippl86VhA'

      client.get 'statuses/user_timeline', (err, tweets, res) ->
        inspect err, 'err'
        inspect res, 'res'
        inspect tweets, 'tweets'
        return
###
      return callback null

  ], (err) ->
    res.json 'hello'
    return

  return

#--------------------------------------------------
# Get
#--------------------------------------------------

module.get = (req, res) ->

  async.waterfall [

    (callback) ->

      return callback null

  ], (err) ->
    res.json 'hello'
    return

  return

#--------------------------------------------------
# Exports
#--------------------------------------------------

module.exports = module

#--------------------------------------------------