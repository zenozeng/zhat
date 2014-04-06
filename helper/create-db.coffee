sqlite3 = require('sqlite3').verbose()

db = new sqlite3.Database 'db.sample.sqlite'

sql = '
  CREATE TABLE `zhat_comments` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `postid` INTERGER,
    `author` VARCHAR(200),
    `content` TEXT,
    `parent` INTERGER );'

sql += '
  CREATE INDEX `pid` ON `zhat_comments` (
    `postid` ASC);'

sql += '
  CREATE TABLE zhat_posts (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "author" VARCHAR(200),
    "content" TEXT );'

sql += '
  CREATE TABLE files (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "content" CLOB );'

db.run sql
