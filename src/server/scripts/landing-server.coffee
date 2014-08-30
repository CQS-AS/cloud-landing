'use strict'

path = require 'path'
cluster = require 'cluster'


if cluster.isMaster
    for i in require('os').cpus()
        cluster.fork()

    cluster.on 'exit', () ->
        cluster.fork()

    return


app = (require 'express')()
app.set 'port', port = parseInt process.argv[2] or '3000', 10

app.use (require 'morgan') 'combined'
app.use (require 'compression')()
app.use (require 'serve-static') path.join __dirname, 'public'
app.use (require 'errorhandler')()

http = (require 'http').createServer app
http.listen port, () ->
    console.log 'Started http server on port', port
