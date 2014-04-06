# Zhat

Zhat is a blog system targeting private bloging.

Still coding.

## Design

### Restful API

```
genQuery = (obj) ->
    obj.timestamp = (new Date()).getTime()
    obj.username = username
    obj.signature = HmacSHA512(JSON.stringify(obj), passphrase)
    obj
```

## Install

### Init Config

```
mv config.sample.json config.json
```

### Init DB

```
mv db.sample.sqlite db.sqlite
```

### Install node-sqlite3

```
sudo apt-get install node-sqlite3
```

### Install Zhat

```
git clone git@github.com:zenozeng/zhat.git
npm install
```

### Config

open config.sample.json, modify it and save as config.json.

As for blog name, blog description, user's avatar, 
they are static resources, so config them in zhat-client.

## Target Feature

### Email Notifications

### Builtin AES encryption (zhat-client)

### XSS 防范 (zhat-client)

### SQL 注入防范
