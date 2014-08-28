module.exports = (grunt) ->

    registerGulp = (task) ->
        grunt.registerTask task, () ->
            grunt.util.spawn
                cmd : 'gulp'
                args: [ task ]
                opts:
                    stdio: 'inherit'
            , @async()


    for task in [ 'default' ]
        registerGulp task
