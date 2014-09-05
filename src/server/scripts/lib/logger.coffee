'use strict'


fmtDate = (date) ->
    "          - - [#{(if date then date else new Date()).toUTCString()}]"


log = () ->
    console.log fmtDate(), (JSON.stringify v for k, v of arguments).join ' '


error = () ->
    console.error fmtDate(), (JSON.stringify v for k, v of arguments).join ' '


onerror = (err) ->
    error err if err


cb = (err, data, callback) ->
    onerror err
    callback? err, if err then null else data


withcb = (callback) ->
    (err, data) ->
        cb err, data, callback


module.exports =
    error  : error
    onerror: onerror

    log    : log

    cb    : cb
    withcb: withcb
