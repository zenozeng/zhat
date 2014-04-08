# Zhat

Zhat is a blog system targeting private bloging.

Still coding.

## Install

```
git clone git@github.com:zenozeng/zhat.git
npm install
mv config.sample.json config.json
gedit config.json
node index.js
```

## Config

open config.sample.json, modify it and save as config.json.

As for blog name, blog description, user's avatar, 
they are static resources, so config them in zhat-client.

## API

### Signature

```
genQuery = (obj) ->
    obj.timestamp = (new Date()).getTime()
    obj.username = username
    obj.signature = HmacSHA512(JSON.stringify(obj), passphrase)
    obj
```

see test/test.sh for more api.
