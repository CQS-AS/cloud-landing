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
uglify     = require 'gulp-uglify'
gutil      = require 'gulp-util'


errcb = (err) ->
    gutil.log gutil.colors.red err.message
    @emit 'end'


gulp.task 'css', () ->
    go = (src = [ 'src/client/styles/**/*.less', '!src/client/styles/**/*.inc.less' ], dest = 'dist/public/styles/', file = 'client.css') ->
        gulp.src src
            .pipe newer "#{dest}#{file}"
            .pipe plumber errcb
            .pipe filelog()
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


gulp.task 'default', [ 'css', 'html', 'coffee-server', 'coffee-client' ]