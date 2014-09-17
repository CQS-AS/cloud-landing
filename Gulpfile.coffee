'use strict'


gulp       = require 'gulp'

coffee     = require 'gulp-coffee'
concat     = require 'gulp-concat'
cssmin     = require 'gulp-cssmin'
filelog    = require 'gulp-filelog'
jade       = require 'gulp-jade'
less       = require 'gulp-less'
newer      = require 'gulp-newer'
annotate   = require 'gulp-ng-annotate'
plumber    = require 'gulp-plumber'
clean      = require 'gulp-rimraf'
uglify     = require 'gulp-uglify'
gutil      = require 'gulp-util'
zip        = require 'gulp-zip'


now = new Date()

distzip = "dist-" + now.getFullYear() + ("0#{now.getMonth() + 1}".slice -2) + ("0#{now.getDate()}".slice -2) + "-" +
    ("0#{now.getHours()}".slice -2) + ("0#{now.getMinutes()}".slice -2) + ("0#{now.getSeconds()}".slice -2) + ".zip"


errcb = (err) ->
    gutil.log gutil.colors.red err.message
    @emit 'end'


gulp.task 'css', () ->
    go = (src = [ 'src/client/styles/**/*.less', '!src/client/styles/**/*.inc.less' ], dest = 'dist/public/styles/', file = 'client.min.css') ->
        gulp.src src
            .pipe newer "#{dest}#{file}"
            .pipe plumber errcb
            .pipe less()
            .pipe cssmin()
            .pipe concat file
            .pipe gulp.dest dest

    go()


gulp.task 'html', () ->
    go = (src = [ 'src/client/views/**/*.jade' ], dest = 'dist/public/', check = 'index.html') ->
        gulp.src src
            .pipe plumber errcb
            .pipe newer "#{dest}#{check}"
            .pipe jade()
            .pipe gulp.dest dest

    go()


gulp.task 'coffee-server', () ->
    go = (src = [ 'src/server/scripts/**/*.coffee' ], dest = 'dist/') ->
        gulp.src src
            .pipe newer
                dest: dest
                ext : '.js'
            .pipe coffee
                bare: true
            .pipe gulp.dest dest

    go()


gulp.task 'coffee-client', () ->
    go = (src = [ 'src/client/scripts/**/*.coffee' ], dest = 'dist/public/scripts/', file = 'client.min.js') ->
        gulp.src src
            .pipe newer "#{dest}#{file}"
            .pipe coffee
                bare: true
            .pipe annotate()
            .pipe uglify()
            .pipe concat file
            .pipe gulp.dest dest

    go()


gulp.task 'copy', () ->
    go = (src, dest) ->
        gulp.src src
            .pipe newer dest
            .pipe gulp.dest dest

    go [ 'src/client/images/**/*' ], 'dist/public/images/'
    go [ 'package.json' ], 'dist/'


gulp.task 'zip-clean', () ->
    go = (src = [ '*.zip', "!#{distzip}" ]) ->
        gulp.src src, { read: false }
            .pipe clean()

    go()


gulp.task 'zip', [ 'build' ], () ->
    go = (src = [ 'dist/**/*' ], dest = '.', arch = distzip) ->
        gulp.src src
            .pipe zip arch
            .pipe gulp.dest dest

    go()


process.on 'uncaughtException', (err) ->
    console.error err


gulp.task 'build', [ 'css', 'html', 'coffee-server', 'coffee-client', 'copy'  ]
gulp.task 'default', [ 'zip', 'zip-clean' ]
