http = require 'http'
express = require 'express'
mysql = require 'mysql'
crypto = require 'crypto'
config = require './lib/config.js'
BaeMessage = require 'bae-message'

########################################
#
# Helpers
#
########################################

response = (res, msg) ->
  if res?
    res.send JSON.stringify msg

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
          callback?(results)
        conn.release();

mail = (to, subject, body) ->
  bae = new BaeMessage config.baeMessage
  bae.mail 'fromAddress', to, subject, body

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
# CREATE TABLES IF NOT EXIST
#
########################################

sql = """
CREATE TABLE IF NOT EXISTS `comments` (
  `id` INT AUTO_INCREMENT,
  `pid` INT,
  `author` VARCHAR(200),
  `timestamp` INT,
  `content` TEXT,
  `parent` INT,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
"""
query null, sql, null

sql = """
CREATE TABLE IF NOT EXISTS `posts` (
  `id` INT AUTO_INCREMENT,
  `author` VARCHAR(200),
  `timestamp` INT,
  `content` TEXT,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
"""
query null, sql, null

sql = """
CREATE TABLE IF NOT EXISTS `files` (
  `id` INT AUTO_INCREMENT,
  `pid` INT,
  `content` LONGTEXT,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
"""
query null, sql, null

########################################
#
# Express Init
#
########################################

app = express()

# auth
app.use (req, res, next) ->
  # unless passAuth(req.query)
  #   response res, {error: "Signature not match"}
  req.query.username = "zenozeng" # authed user
  next()

app.use express.bodyParser()

########################################
#
# Posts
#
########################################

# get posts list
app.get '/posts', (req, res) ->
  sql = "SELECT id, author, timestamp FROM posts"
  query res, sql, (results) ->
    response res, {posts: results}

# get posts by id
app.get /posts\/(\d+)$/, (req, res) ->
  id = req.params[0]
  sql = "SELECT * FROM posts WHERE id=?"
  query res, sql, id, (results) ->
    if results.length > 0
      post = results[0]
      sql = "SELECT * FROM comments WHERE pid=?"
      query res, sql, id, (comments) ->
        post.comments = comments
        response res, post
    else
      response res, {error: "404 NOT FOUND"}

# add post
app.post '/posts', (req, res) ->
  {username} = req.query
  {content} = req.body
  timestamp = (new Date()).getTime()

  sql = "INSERT INTO posts (author, timestamp, content) VALUES (?, ?, ?)"
  query res, sql, username, timestamp, content, (results) ->
    response res, {msg: "ok!"}

# update post
app.post /posts\/(\d+)$/, (req, res) ->
  id = req.params[0]
  {content} = req.body
  sql = "UPDATE posts SET content=? WHERE id=?"
  query res, sql, content, id, (results) ->
    response res, {msg: "ok!"}

########################################
#
# Comments
#
########################################

# add comment
app.post '/comments', (req, res) ->
  {username} = req.query
  timestamp = (new Date()).getTime()
  {pid, content, parent} = req.body

  sql = "INSERT INTO comments (author, pid, timestamp, content, parent) VALUES (?, ?, ?, ?, ?)"
  query res, sql, username, pid, timestamp, content, parent, (results) ->
    response res, {msg: "ok!"}

########################################
#
# Files
#
########################################

# add file
app.post '/files', (req, res) ->
  console.log req.body
  {content, pid} = req.body
  sql = "INSERT INTO files (content, pid) VALUES (?, ?)"
  query res, sql, content, pid, (results) ->
    response res, {msg: "ok!"}

# get file by id
app.get /files\/(\d+)$/, (req, res) ->
  id = req.params[0]
  sql = "SELECT * FROM files WHERE id=?"
  query res, sql, id, (results) ->
    if results.length > 0
      response res, results[0]
    else
      response res, {error: "404 NOT FOUND"}

########################################
#
# Handle 404 & Start
#
########################################

app.use (req, res, next) ->
  response res, {error: "404 NOT FOUND"}

app.listen config.etc.port
