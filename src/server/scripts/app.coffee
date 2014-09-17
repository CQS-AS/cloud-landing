'use strict'

path = require 'path'
cluster = require 'cluster'

l = require './lib/logger'

cfg = require './cfg/cfg'


if cluster.isMaster
    l.log cfg

    for i in require('os').cpus()
        cluster.fork()

    cluster.on 'exit', () ->
        cluster.fork()

    return

port = process.env.PORT || 3000

app = (require 'express')()
app.set 'port', port

app.use (require 'morgan') 'combined'
app.use (require 'compression')()
app.use (require 'body-parser').json()
app.use (require 'serve-static') path.join __dirname, 'public'
app.use (require 'errorhandler')()

(require './lib/api').init cfg, app
(require './lib/mail').init cfg, app

app.get '/', (req, res) ->
    res.status(200).sendFile cfg.index[req.hostname] || cfg.index.default, { root: './public' }

http = (require 'http').createServer app
http.listen port, () ->
    l.log 'Started http server on port', port
