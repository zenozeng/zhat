sqlite3 = require('sqlite3').verbose()

db = new sqlite3.Database 'db.sample.sqlite'

sql = '
  CREATE TABLE `comments` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `postid` INTERGER,
    `author` VARCHAR(200),
    "timestamp" INTEGER,
    `content` TEXT,
    `parent` INTERGER );'

sql += '
  CREATE INDEX `pid` ON `comments` (
    `postid` ASC);'

sql += '
  CREATE TABLE posts (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "author" VARCHAR(200),
    "timestamp" INTEGER,
    "content" TEXT );'

sql += '
  CREATE TABLE files (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "postid" INTERGER,
    "content" CLOB );'

db.run sql
