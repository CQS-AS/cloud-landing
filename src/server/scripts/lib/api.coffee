'use strict'

mail = require './mail'
l = require './logger'


sendJson = (res, code, obj) ->
    res.set 'Cache-Control', 'private, no-cache, no-store, must-revalidate'
    res.set 'Expires', '-1'
    res.set 'Pragma', 'no-cache'
    (res.status code).json obj


sendOk = (res, obj) ->
    sendJson res, 200, { res: obj or {} }


sendErr = (res, err) ->
    l.error err
    sendJson res, 500, { err: err }


send = (res, err, obj) ->
    if err
        sendErr res, err
    else
        sendOk res, obj


requestInvite = (req, res) ->
    #l.log 'requestInvite', req.body
    mail.sendInviteReq req.body
    sendOk res


init = (cfg, app) ->
    l.log 'Api.init: Initialising'
    app.post '/api/1/invite', requestInvite


module.exports =
    init: init