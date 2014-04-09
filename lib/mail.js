var BaeMessage = require('bae-message');

var Mail = function(config) {
    var baeAvaliable = (typeof config.baeMessage.key != "undefined");
    this.send = function(from, to, subject, body) {
        if(baeAvaliable) {
            var bae = new BaeMessage(config.baeMessage);
            bae.mail(from, to, subject, body);
        } else {
            console.err("ERR: BAE is not avaliable.");
        }
    }
}

moudle.exprots = Mail;