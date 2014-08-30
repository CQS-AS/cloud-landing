'use strict';
var app, cluster, http, i, path, port, _i, _len, _ref;

path = require('path');

cluster = require('cluster');

if (cluster.isMaster) {
  _ref = require('os').cpus();
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    cluster.fork();
  }
  cluster.on('exit', function() {
    return cluster.fork();
  });
  return;
}

app = (require('express'))();

app.set('port', port = parseInt(process.argv[2] || '3000', 10));

app.use((require('morgan'))('combined'));

app.use((require('compression'))());

app.use((require('serve-static'))(path.join(__dirname, 'public')));

app.use((require('errorhandler'))());

http = (require('http')).createServer(app);

http.listen(port, function() {
  return console.log('Started http server on port', port);
});
