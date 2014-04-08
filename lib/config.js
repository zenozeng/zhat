var fs = require('fs');
var config = JSON.parse(fs.readFileSync('../config.json'));

if(config.etc.usebae) {
    config.db.host = process.env.BAE_ENV_ADDR_SQL_IP;
    config.db.port = process.env.BAE_ENV_ADDR_SQL_PORT;
    config.db.user = process.env.BAE_ENV_AK;
    config.db.password = process.env.BAE_ENV_SK;
    config.etc.port = process.env.APP_PORT;
}

// Determines the pool's action when no connections are available and the limit has been reached. If true, the pool will queue the connection request and call it when one becomes available. If false, the pool will immediately call back with an error. (Default: true)
config.db.waitForConnections = true;

// The maximum number of connections to create at once. (Default: 10)
config.db.connectionLimit = 10;

// The maximum number of connection requests the pool will queue before returning an error from getConnection. If set to 0, there is no limit to the number of queued connection requests. (Default: 0)
config.db.queueLimit = 0;

module.exports = config;