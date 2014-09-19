'use strict'

path = require 'path'
cluster = require 'cluster'

l = require './lib/logger'

cfg = require './cfg'


if cluster.isMaster
    for i in (if (cfg.get 'cluster') then require('os').cpus() else [ 1 ])
        cluster.fork()

    cluster.on 'exit', () ->
        cluster.fork()

    return

port = process.env.PORT || 3000

app = (require 'express')()
app.set 'port', port

(require './lib/status').init cfg, app

app.use (require 'morgan') 'combined'
app.use (require 'compression')()
app.use (require 'body-parser').json()
app.use (require 'serve-static') path.join __dirname, 'public'
app.use (require 'errorhandler')()

(require './lib/api').init cfg, app
(require './lib/mail').init cfg, app

app.get '/', (req, res) ->
    res.sendFile (cfg.get 'index', req.hostname), { root: './public' }

http = (require 'http').createServer app
http.listen port, () ->
    l.log 'Started http server on port', port
