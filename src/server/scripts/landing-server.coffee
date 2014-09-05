'use strict'

path = require 'path'
cluster = require 'cluster'

l = require './lib/logger'

cfg = require "./cfg/#{process.argv[2] or 'dev'}"


if cluster.isMaster
    l.log cfg
    cpus = if cfg.cluster then require('os').cpus() else [ 1 ]

    for i in cpus
        cluster.fork()

    cluster.on 'exit', () ->
        cluster.fork()

    return


app = (require 'express')()
app.set 'port', cfg.port

app.use (require 'morgan') 'combined'
app.use (require 'compression')()
app.use (require 'body-parser').json()
app.use (require 'serve-static') path.join __dirname, 'public'
app.use (require 'errorhandler')()

(require './lib/api').init cfg, app
(require './lib/mail').init cfg, app

http = (require 'http').createServer app
http.listen cfg.port, () ->
    l.log 'Started http server on port', cfg.port
