'use strict';
var cfg, init, l, mandrill, sendInviteReq, sendTemplate;

mandrill = require('mandrill-api');

l = require('./logger');

cfg = null;

sendInviteReq = function(r) {
  var tmpl, _ref, _ref1, _ref2, _ref3;
  tmpl = {
    name: ((_ref = cfg.mandrill.tmpl) != null ? (_ref1 = _ref.invite) != null ? _ref1.t : void 0 : void 0) || 'cloud-invite-request',
    subject: ((_ref2 = cfg.mandrill.tmpl) != null ? (_ref3 = _ref2.invite) != null ? _ref3.s : void 0 : void 0) || 'CaseWare Cloud Invite Request',
    cont: null,
    html: null,
    text: null,
    tags: ['invite-request'],
    vars: []
  };
  return sendTemplate(tmpl, [
    {
      email: 'sales@cqscloud.com',
      name: 'Sales',
      meta: {},
      vars: [
        {
          name: 'FIRSTNAME',
          content: r.firstname
        }, {
          name: 'LASTNAME',
          content: r.lastname
        }, {
          name: 'EMAIL',
          content: r.email
        }, {
          name: 'PHONE',
          content: r.phone
        }, {
          name: 'ADDRESS',
          content: r.address
        }, {
          name: 'COUNTRY',
          content: r.country
        }, {
          name: 'FIRMNAME',
          content: r.firmname
        }, {
          name: 'FIRMSHORT',
          content: r.firmshort
        }, {
          name: 'CLIENTNO',
          content: r.clientno
        }, {
          name: 'EMPLOYEES',
          content: r.employees
        }, {
          name: 'CWT',
          content: r.cwt
        }
      ]
    }
  ]);
};

sendTemplate = function(tmpl, recipients, cb) {
  var opt, r;
  opt = {
    'template_name': tmpl.name,
    'template_content': tmpl.cont,
    'async': false,
    'ip_pool': 'Main Pool',
    'send_at': null,
    'message': {
      'html': tmpl.html,
      'text': tmpl.text,
      'subject': tmpl.subject,
      'from_email': cfg.mail.email,
      'from_name': cfg.mail.name,
      'headers': {
        'Reply-To': cfg.mail.email
      },
      'important': false,
      'merge': true,
      'tags': tmpl.tags,
      'global_merge_vars': tmpl.vars,
      'metadata': {
        'website': cfg.mail.site
      },
      'recipient_metadata': (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = recipients.length; _i < _len; _i++) {
          r = recipients[_i];
          _results.push({
            'rcpt': r.email,
            'values': r.meta
          });
        }
        return _results;
      })(),
      'to': (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = recipients.length; _i < _len; _i++) {
          r = recipients[_i];
          _results.push({
            'email': r.email,
            'name': r.name
          });
        }
        return _results;
      })(),
      'merge_vars': (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = recipients.length; _i < _len; _i++) {
          r = recipients[_i];
          _results.push({
            'rcpt': r.email,
            'vars': r.vars
          });
        }
        return _results;
      })(),
      'track_opens': null,
      'track_clicks': null,
      'auto_text': null,
      'auto_html': null,
      'inline_css': null,
      'url_strip_qs': null,
      'preserve_recipients': null,
      'bcc_address': null,
      'tracking_domain': null,
      'signing_domain': null,
      'return_path_domain': null,
      'attachments': null,
      'images': null,
      'google_analytics_domains': null,
      'google_analytics_campaign': null
    }
  };
  l.log('Main.sendTemplate', 'Ready to send', opt);
  (new mandrill.Mandrill(cfg.mandrill.key)).messages.sendTemplate(opt, function(result) {
    l.log('Mail.sentTemplate', 'Mandrill send ok', result);
    if (typeof cb === "function") {
      cb(null, result);
    }
    return cb = null;
  }, l.withcb(cb));
};

init = function(c, app) {
  l.log('Mail.init: Initialising');
  return cfg = c;
};

module.exports = {
  init: init,
  sendInviteReq: sendInviteReq
};
