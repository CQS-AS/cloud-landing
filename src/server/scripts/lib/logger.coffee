'use strict'

cluster = require 'cluster'


fmtDate = (date) ->
    if cluster.isWorker
        "#Worker #{cluster.worker.id} - - [#{(if date then date else new Date()).toUTCString()}]"
    else
        "#DaMaster - - [#{(if date then date else new Date()).toUTCString()}]"


fmtArgs = (args) ->
    (for k, v of args
        if Object.prototype.toString.call(v) is '[object Error]'
            "[#{v.toString()}]"
        else
            JSON.stringify v
    ).join ' '


log = () ->
    console.log fmtDate(), fmtArgs arguments


error = () ->
    console.error fmtDate(), fmtArgs arguments


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
