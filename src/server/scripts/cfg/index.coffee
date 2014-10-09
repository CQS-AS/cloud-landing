'user strict'

env =
    'cloud.casewareafrica.com': 'africa'
    'dev'                     : 'dev'
    'africa'                  : 'africa'

types =
    default:
        cluster : true
        index   : 'index-cqs.html'

        mail    : require './cfg/mail'
        mandrill: require './cfg/mandrill'

    africa:
        index   : 'index-africa.html'

    dev:
        cluster: false


get = (key, hostname) ->
    type = env[process.env.ENV || hostname]

    if types[type]?[key]?
        types[type][key]
    else
        types.default[key]


module.exports =
    get: get

