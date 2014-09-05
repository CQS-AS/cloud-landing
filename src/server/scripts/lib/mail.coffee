'use strict'

mandrill = require 'mandrill-api'

l = require './logger'

cfg = null


sendInviteReq = (r) ->
    #l.log 'sendInviteReq', r

    tmpl =
        name   : cfg.mandrill.tmpl?.invite?.t || 'cloud-invite-request'
        subject: cfg.mandrill.tmpl?.invite?.s || 'CaseWare Cloud Invite Request'
        cont   : null
        html   : null
        text   : null
        tags   : [ 'invite-request' ]
        vars   : [] 

    sendTemplate tmpl, [
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
            { name:'EMPLOYEES', content: r.employees }
            { name:'CWT',       content: r.cwt }
        ]
    ]


sendTemplate = (tmpl, recipients, cb) ->
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
            'from_email'               : cfg.mail.email
            'from_name'                : cfg.mail.name
            'headers'                  : { 'Reply-To': cfg.mail.email }
            'important'                : false
            'merge'                    : true
            'tags'                     : tmpl.tags
            'global_merge_vars'        : tmpl.vars
            'metadata'                 : { 'website': cfg.mail.site }
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

    (new mandrill.Mandrill cfg.mandrill.key).messages.sendTemplate opt, (result) ->
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
