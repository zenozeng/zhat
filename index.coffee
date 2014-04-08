http = require 'http'
express = require 'express'
mysql = require 'mysql'
crypto = require 'crypto'
config = require './lib/config.js'

########################################
#
# Helpers
#
########################################

response = (res, msg) -> res.send JSON.stringify msg

dbPool = mysql.createPool config.db # 会自动重连
query = (res, sql, args..., callback) ->
  dbPool.getConnection (err, conn) ->
    if err
      console.log err
      response res, {err: "SQL ERROR: fail to get connection"}
    else
      conn.query sql, args, (err, results) ->
        if err
          console.log err
          response res, {err: "SQL ERROR: fail to query"}
        else
          callback(results)
        conn.release();

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

########################################
#
# Express Init
#
########################################

app = express()

# auth
app.use (req, res, next) ->
  # unless passAuth(req.query)
  #   response {error: "Signature not match"}
  req.query.username = "zenozeng" # authed user
  next()

########################################
#
# Posts
#
########################################

# get posts list
app.get '/posts', (req, res) ->
  response res, {posts: []}

# get posts by id
app.get /posts\/(\d+)$/, (req, res) ->
  id = req.params[0]
  response res, {id: id}

# add post
# TODO: update post if post already exits
app.post '/posts', (req, res) ->
  {username} = req.query
  {content} = req.body
  timestamp = (new Date()).getTime()

  sql = "INSERT INTO posts (author, timestamp, content) VALUES (?, ?, ?)"
  query res, sql, username, timestamp, content, (results) ->
    response {msg: "ok!"}

########################################
#
# Comments
#
########################################

# add comment
app.post '/comments', (req, res) ->
  {username} = req.query
  timestamp = (new Date()).getTime()
  {postid, content, parent} = req.body

  sql = "INSERT INTO comments (author, postid, timestamp, content, parent) VALUES (?, ?, ?)"
  query res, sql, username, postid, timestamp, content, parent, (results) ->
    response {msg: "ok!"}

########################################
#
# Files
#
########################################

# add file
app.post '/files', (req, res) ->
  {content, postid} = req.body
  sql = "INSERT INTO files (content, postid) VALUES (?, ?)"
  query res, sql, content, postid, (results) ->
    response {msg: "ok!"}

# get file by id
app.get /files\/(\d+)$/, (req, res) ->
  id = req.params[0]
  sql = "SELECT * FROM files WHERE id=?"
  query, res, sql, id, (results) ->
    console.log results

########################################
#
# Handle 404 & Start
#
########################################

app.use (req, res, next) ->
  response res, {error: "404 NOT FOUND"}

app.listen config.blog.port
