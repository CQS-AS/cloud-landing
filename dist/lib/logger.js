'use strict';
var cb, error, fmtDate, log, onerror, withcb;

fmtDate = function(date) {
  return "          - - [" + ((date ? date : new Date()).toUTCString()) + "]";
};

log = function() {
  var k, v;
  return console.log(fmtDate(), ((function() {
    var _results;
    _results = [];
    for (k in arguments) {
      v = arguments[k];
      _results.push(JSON.stringify(v));
    }
    return _results;
  }).apply(this, arguments)).join(' '));
};

error = function() {
  var k, v;
  return console.error(fmtDate(), ((function() {
    var _results;
    _results = [];
    for (k in arguments) {
      v = arguments[k];
      _results.push(JSON.stringify(v));
    }
    return _results;
  }).apply(this, arguments)).join(' '));
};

onerror = function(err) {
  if (err) {
    return error(err);
  }
};

cb = function(err, data, callback) {
  onerror(err);
  return typeof callback === "function" ? callback(err, err ? null : data) : void 0;
};

withcb = function(callback) {
  return function(err, data) {
    return cb(err, data, callback);
  };
};

module.exports = {
  error: error,
  onerror: onerror,
  log: log,
  cb: cb,
  withcb: withcb
};
