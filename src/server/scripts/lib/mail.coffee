'use strict'

mandrill = require 'mandrill-api'

l = require './logger'

cfg = null


sendInviteReq = (hostname, r) ->
    c = cfg.get 'mail', hostname

    tmpl =
        name   : c.tmpl.invite.t
        subject: c.tmpl.invite.s
        cont   : null
        html   : null
        text   : null
        tags   : [ 'invite-request' ]
        vars   : [] 

    sendTemplate hostname, tmpl, [
        email: 'sales@cqscloud.com'
        name: 'Sales'
        meta: {}
        vars: [
            { name:'FIRSTNAME', content: r.firstname }
            { name:'LASTNAME',  content: r.lastname }
            { name:'EMAIL',     content: r.email }
            { name:'PHONE',     content: r.phone }
            { name:'ADDRESS',   content: r.address }
            { name:'COUNTRY',   content: r.country }
            { name:'FIRMNAME',  content: r.firmname }
            { name:'FIRMSHORT', content: r.firmshort }
            { name:'CLIENTNO',  content: r.clientno }
            { name:'EMPLOYEES', content: r.employees }
            { name:'CWT',       content: r.cwt }
        ]
    ]


sendTemplate = (hostname, tmpl, recipients, cb) ->
    c = cfg.get 'mail', hostname

    opt =
        'template_name'                : tmpl.name
        'template_content'             : tmpl.cont
        'async'                        : false
        'ip_pool'                      : 'Main Pool'
        'send_at'                      : null
        'message'                      :
            'html'                     : tmpl.html
            'text'                     : tmpl.text
            'subject'                  : tmpl.subject
            'from_email'               : c.email
            'from_name'                : c.name
            'headers'                  : { 'Reply-To': c.email }
            'important'                : false
            'merge'                    : true
            'tags'                     : tmpl.tags
            'global_merge_vars'        : tmpl.vars
            'metadata'                 : { 'website': c.url }
            'recipient_metadata'       : { 'rcpt'  : r.email, 'values': r.meta } for r in recipients
            'to'                       : { 'email': r.email, 'name' : r.name } for r in recipients
            'merge_vars'               : { 'rcpt': r.email, 'vars': r.vars } for r in recipients
            'track_opens'              : null
            'track_clicks'             : null
            'auto_text'                : null
            'auto_html'                : null
            'inline_css'               : null
            'url_strip_qs'             : null
            'preserve_recipients'      : null
            'bcc_address'              : null
            'tracking_domain'          : null
            'signing_domain'           : null
            'return_path_domain'       : null
            'attachments'              : null
            'images'                   : null
            'google_analytics_domains' : null
            'google_analytics_campaign': null

    l.log 'Main.sendTemplate', 'Ready to send', opt

    (new mandrill.Mandrill (cfg.get 'mandrill', hostname).key).messages.sendTemplate opt, (result) ->
        l.log 'Mail.sentTemplate', 'Mandrill send ok', result
        cb? null, result
        cb = null

    , l.withcb cb

    return


init = (c, app) ->
    l.log 'Mail.init: Initialising'
    cfg = c


module.exports =
    init: init

    sendInviteReq: sendInviteReq
