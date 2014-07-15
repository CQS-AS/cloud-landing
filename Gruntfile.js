module.exports = function(grunt) {

    grunt.initConfig({

        jade: {
            client: {
                options: {
                    data: {
                        debug : false,
                        pretty: false
                    }
                },
                files: [ {
                    cwd: "src/client/views",
                    src: "**/*.jade",
                    dest: "dist/public",
                    expand: true,
                    ext: ".html"
                } ]
            }
        },

        less: {
            client: {
                options: {
                    paths: ['assets/css'],
                    cleancss: true
                },
                files: {
                    'dist/public/styles/client.min.css': 'src/client/styles/client.less'
                }
            }
        },

        uglify: {
            client: {
                src : 'src/client/scripts/*.js',
                dest : 'dist/public/scripts/client.min.js'
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jade');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-uglify');

    grunt.registerTask('buildViews',   [ 'jade:client' ]);
    grunt.registerTask('buildStyles',  [ 'less:client' ]);
    grunt.registerTask('buildScripts', [ 'uglify:client' ]);

    grunt.registerTask('buildHtml', [ 'buildStyles', 'buildViews' ]);

    grunt.registerTask('all', [ 'buildHtml', 'buildScripts' ]);

};