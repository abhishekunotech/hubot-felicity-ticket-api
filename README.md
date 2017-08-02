# hubot-felicity-ticket-api

A hubot script that will connect to the Felicity Service Desk - Integration Platform

See [`src/felicity-ticket-api.coffee`](src/felicity-ticket-api.coffee) for full documentation.


## TRAVIS STATUS

Travis Status: [![Build Status](https://travis-ci.org/abhishekunotech/hubot-felicity-ticket-api.svg?branch=feature-human-communication)](https://travis-ci.org/abhishekunotech/hubot-felicity-ticket-api) 

## Installation

In hubot project repo, run:

`npm install hubot-felicity-ticket-api --save`

Then add **hubot-felicity-ticket-api** to your `external-scripts.json`:

```json
[
  "hubot-felicity-ticket-api"
]
```

## Sample Interaction

```
user1>> hubot configure base http://192.168.2.108/felicity/
user1>> set ticket id 521
user1>> set username abhik
user1>> set userpassword asfpasfp
user1>> get ticket details
hubot>> Request Successful <json_of_ticket_521>
```

## NPM Module

https://www.npmjs.com/package/hubot-felicity-ticket-api



## Updating the Code in RocketChat

npm version patch
npm publish

`Add the current version of npm in rocketchat's package.json`
`bin/hubot -a rocketchat`


## Updating the Code in RocketChat

`npm version <major|minor|patch|prepatch>`
`npm publish`

`Update the package.json in RocketChat`
`bin/hubot -a rocketchat "Will Update the Package"`

