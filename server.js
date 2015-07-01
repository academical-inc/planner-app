var express = require('express');
var compression = require('compression');

var app = express();

app.use(compression());
app.use(express.static(__dirname + '/dist'));

var port = process.env.PORT || 5000
console.log("Server listening at:" + port);
app.listen(port);
