http = require 'http'
fs = require 'fs'
connect = require 'connect'
sqlite3 = require('sqlite3').verbose()
express = require 'express'

config = JSON.parse fs.readFileSync 'config.json'
db = new sqlite3.Database 'db.sqlite'

response = (res, msg) -> res.send JSON.stringify msg

passAuth = (query) ->
  {username, signature} = query
  return false unless signature?
  return false unless config.users[username]?
  delete query.signature
  key = (new Buffer(config.users[username].passphrase)).toString('hex')
  hmac = crypto.createHmac 'sha512', key
  hmac.setEncoding 'hex'
  hmac.write JSON.stringify(query)
  hmac.end()
  hmac.read() is signature

app = express()

# auth
app.use (req, res, next) ->
  unless passAuth(req.query)
    response {error: "Signature not match"}
  next()

app.param('id', /^\d+$/)
app.get '/posts/:id', (req, res) ->
  null

app.listen config.blog.port
