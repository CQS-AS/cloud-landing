'use strict'


gulp       = require 'gulp'

coffee     = require 'gulp-coffee'
concat     = require 'gulp-concat'
cssmin     = require 'gulp-cssmin'
filelog    = require 'gulp-filelog'
jade       = require 'gulp-jade'
less       = require 'gulp-less'
newer      = require 'gulp-newer'
plumber    = require 'gulp-plumber'
uglify     = require 'gulp-uglify'
gutil      = require 'gulp-util'


append = (list, post) ->
    n = []
    for p in post
        for l in list
            n.push "#{l}#{if l[l.length - 1] is '/' then p else ''}"

    n


errcb = (err) ->
    gutil.log gutil.colors.red err.message
    @emit 'end'



gulp.task 'css', () ->
    go = (src = [ 'src/client/' ], dest = 'dist/public/styles/', file = 'client.css') ->
        gulp.src append src, [ 'styles/**/*.less' ]
            .pipe newer "#{dest}#{file}"
            .pipe plumber errcb
            .pipe filelog()
            .pipe less()
            .pipe cssmin()
            .pipe concat file
            .pipe gulp.dest dest

    go()


gulp.task 'html', () ->
    go = (src = [ 'src/client/' ], dest = 'dist/public/', check = 'index.html') ->
        gulp.src append src, [ 'views/**/*.jade' ]
            .pipe plumber errcb
            .pipe newer "#{dest}#{check}"
            .pipe jade()
            .pipe gulp.dest dest

    go()


gulp.task 'coffee-server', () ->
    go = (src = [ 'src/server/' ], dest = 'dist/') ->
        gulp.src append src, [ 'scripts/**/*.coffee' ]
            .pipe newer
                dest: dest
                ext : '.js'
            .pipe coffee
                bare: true
            .pipe gulp.dest dest

    go()


gulp.task 'coffee-client', () ->
    go = (src = [ 'src/client/' ], dest = 'dist/public/scripts/', file = 'client.min.js') ->
        gulp.src append src, [ 'scripts/**/*.coffee' ]
            .pipe newer "#{dest}#{file}"
            .pipe coffee
                bare: true
            .pipe concat file
            .pipe uglify()
            .pipe gulp.dest dest

    go()


gulp.task 'default', [ 'css', 'html', 'coffee-server', 'coffee-client' ]