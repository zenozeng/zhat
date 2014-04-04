sqlite3 = require('sqlite3').verbose()

db = new sqlite3.Database 'db.sample.sqlite'

db.run 'CREATE TABLE `zhat_comments` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `postid` INTERGER,
  `author` VARCHAR(200),
  `content` TEXT,
  `parent` INTERGER );'

db.run 'CREATE INDEX `pid` ON `zhat_comments` (`postid` ASC)'

db.run 'CREATE TABLE zhat_posts (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "author" VARCHAR(200),
  "content" TEXT );'
