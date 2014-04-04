http = require "http"
fs = require "fs"
connect = require "connect"

unless fs.existsSync "config.json"
  throw "Err: config.json not found"

http.createServer(app).listen 8080
