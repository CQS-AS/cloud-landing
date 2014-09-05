'use strict';
var init, l, mail, requestInvite, send, sendErr, sendJson, sendOk;

mail = require('./mail');

l = require('./logger');

sendJson = function(res, code, obj) {
  res.set('Cache-Control', 'private, no-cache, no-store, must-revalidate');
  res.set('Expires', '-1');
  res.set('Pragma', 'no-cache');
  return (res.status(code)).json(obj);
};

sendOk = function(res, obj) {
  return sendJson(res, 200, {
    res: obj || {}
  });
};

sendErr = function(res, err) {
  l.error(err);
  return sendJson(res, 500, {
    err: err
  });
};

send = function(res, err, obj) {
  if (err) {
    return sendErr(res, err);
  } else {
    return sendOk(res, obj);
  }
};

requestInvite = function(req, res) {
  mail.sendInviteReq(req.body);
  return sendOk(res);
};

init = function(cfg, app) {
  l.log('Api.init: Initialising');
  return app.post('/api/1/invite', requestInvite);
};

module.exports = {
  init: init
};
