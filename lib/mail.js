var BaeMessage = require('bae-message');

var Mail = function(config) {
    var bae = new BaeMessage(config.baeMessage);
    this.send = function(from, to, subject, body) {
        var bae = new BaeMessage()
        bae.mail(from, to, subject, body);
    }
}

moudle.exprots = Mail;