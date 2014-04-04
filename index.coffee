http = require 'http'
fs = require 'fs'
connect = require 'connect'
sqlite3 = require('sqlite3').verbose()
express = require 'express'

config = JSON.parse fs.readFileSync 'config.json'

db = new sqlite3.Database 'db.sqlite'

# init database

app = express()

http.createServer(app).listen config.blog.port
