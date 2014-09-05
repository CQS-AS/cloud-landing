'use strict';
var app, cfg, cluster, cpus, http, i, l, path, _i, _len;

path = require('path');

cluster = require('cluster');

l = require('./lib/logger');

cfg = require("./cfg/" + (process.argv[2] || 'dev'));

if (cluster.isMaster) {
  l.log(cfg);
  cpus = cfg.cluster ? require('os').cpus() : [1];
  for (_i = 0, _len = cpus.length; _i < _len; _i++) {
    i = cpus[_i];
    cluster.fork();
  }
  cluster.on('exit', function() {
    return cluster.fork();
  });
  return;
}

app = (require('express'))();

app.set('port', cfg.port);

app.use((require('morgan'))('combined'));

app.use((require('compression'))());

app.use((require('body-parser')).json());

app.use((require('serve-static'))(path.join(__dirname, 'public')));

app.use((require('errorhandler'))());

(require('./lib/api')).init(cfg, app);

(require('./lib/mail')).init(cfg, app);

http = (require('http')).createServer(app);

http.listen(cfg.port, function() {
  return l.log('Started http server on port', cfg.port);
});
