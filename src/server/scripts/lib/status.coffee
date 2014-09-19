'use strict'

r = require './api'


getStatus = (req, res) ->
    mem = process.memoryUsage()
    uptime = Math.round process.uptime()

    upsec = uptime % 60
    uptime = (uptime - upsec)/60
    upstr = "#{upsec}s"

    if uptime
        upmin = uptime % 60
        uptime = (uptime - upmin)/60
        upstr = "#{upmin}m #{upstr}"

        if uptime
            uphr = uptime % 24
            uptime = (uptime - uphr)/24
            upstr = "#{uphr}h #{upstr}"

            if uptime
                upstr = "#{uptime}d #{upstr}"

    r.sendOk res,
        mem:
            rss  : "#{Math.floor mem.rss/1048576}MB"
            total: "#{Math.floor mem.heapTotal/1048576}MB"
            used : "#{Math.floor mem.heapUsed/1048576}MB"
        uptime  : upstr
        hostname: req.hostname


init = (cfg, app) ->
    app.get '/status', getStatus
    return


module.exports =
    init: init