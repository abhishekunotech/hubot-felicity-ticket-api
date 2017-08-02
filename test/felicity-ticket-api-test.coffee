Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/felicity-ticket-api.coffee')

describe 'felicity-ticket-api', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    

  it 'responds to configure command', ->
    @room.user.say('alice', '@tebot configure').then =>
      expect(@room.messages).to.eql [
        ['alice', '@tebot configure']
        ['hubot', 'Starting Configuration..\n 1. Base URL \n 2. User Name\n 3. Password\n 4. TicketID']
      ]
  #need to add tests for the rest
