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
  # unless passAuth(req.query)
  #   response {error: "Signature not match"}
  req.query.username = "zenozeng" # authed user
  next()

# posts list
app.get '/posts', (req, res) ->
  response res, {posts: []}

# add post
app.post '/posts', (req, res) ->
  {username} = req.query
  {content} = req.body
  timestamp = (new Date()).getTime()
  sql = "INSERT INTO posts (author, timestamp, content) VALUES (?, ?, ?)"
  db.run sql, username, timestamp, content, (err) ->
    if err
      response res, {err: "SQL ERROR"}
    else
      response res, {msg: "ok!"}

# add comment
app.post '/comments', (req, res) ->
  {username} = req.query

# get posts by id
app.get /posts\/(\d+)$/, (req, res) ->
  id = req.params[0]
  response res, {id: id}

# get file by id
app.get /files\/(\d+)$/, (req, res) ->
  id = req.params[0]
  response res, {id: id}

app.use (req, res, next) ->
  response res, {error: "404"}

app.listen config.blog.port
