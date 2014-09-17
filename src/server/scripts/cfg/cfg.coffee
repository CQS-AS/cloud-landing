module.exports =
    mail    : require './mail'
    mandrill: require './mandrill'

    index:
        default                   : 'index-cqs.html'
        'cloud.casewareafrica.com': 'index-africa.html'
