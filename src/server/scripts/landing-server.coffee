'use strict'

path = require 'path'
cluster = require 'cluster'


if cluster.isMaster
    for i in require('os').cpus()
        cluster.fork()

    cluster.on 'exit', () ->
        cluster.fork()

else
    try
        port = parseInt (require "./cfg/#{cfgarg}"), 10

        console.log 'Initialising child process'

        app = (require 'express')()
        app.set 'port', port
        app.use (require 'morgan')() # logging
        app.use (require 'static-favicon')()
        app.use (require 'compression')()
        app.use (require 'body-parser')()
        app.use (require 'method-override')()
        app.use (require 'connect-busboy')()
        app.use (require 'serve-static') path.join __dirname, '..', 'public'
        app.use (require 'errorhandler')()

        http = (require 'http').createServer app
        http.listen port, () ->
            console.log 'Started http server on port', port

    catch e
        console.error 'Usage: install-landing <port>'
        console.error e
