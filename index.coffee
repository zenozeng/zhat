http = require 'http'
fs = require 'fs'
connect = require 'connect'
sqlite3 = require('sqlite3').verbose()

config = JSON.parse fs.readFileSync 'config.json'

db = new sqlite3.Database 'db.sqlite'

db.run 'CREATE TABLE IF NOT EXISTS zhat_comments (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "pid" INTERGER,
  "author" VARCHAR(200),
  "content" TEXT,
  "parent" INTERGER );'

db.run 'CREATE TABLE IF NOT EXISTS zhat_posts (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "author" VARCHAR(200),
  "content" TEXT );'

http.createServer(app).listen 8080
