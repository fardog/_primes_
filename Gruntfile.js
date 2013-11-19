module.exports = function(grunt) {
	var jsFiles = [
		'assets/js/underscore.min.js',
		'assets/js/jquery.min.js',
		'assets/js/jquery.hashchange.js',
		'assets/js/knockout.js',
		'assets/js/app.js'
	];

	var cssFiles = [
		'assets/css/app.css'
	];

	grunt.initConfig({
		uglify: {
			dist: {
				files: {
					'assets/js/app.min.js': jsFiles
				}
			},
			deploy: {
				files: {
					'www/assets/js/app.min.js': jsFiles
				}
			},
			dev: {
				options: {
					beautify: {
						width: 80,
						beautify: true
					}
				},
				files: {
					'assets/js/app.min.js': jsFiles
				}
			}
		},
		sass: {
			dist: {
				files: {
					'assets/css/app.css': 'src/app.scss'
				}
			},
			deploy: {
				files: {
					'www/assets/css/app.css': 'src/app.scss'
				}
			}
		},
		jade: {
			dist: {
				options: {
					data: {
						js: ['assets/js/app.min.js'],
						css: ['assets/css/app.css']
					}
				},
				files: {
					'index.html': ['src/index.jade']
				}
			},
			deploy: {
				options: {
					data: {
						js: ['assets/js/app.min.js'],
						css: ['assets/css/app.css']
					}
				},
				files: {
					'www/index.html': ['src/index.jade']
				}
			},
			dev: {
				options: {
					data: {
						js: jsFiles,
						css: ['assets/css/app.css']
					}
				},
				files: {
					'index.html': ['src/index.jade']
				}
			}
		},
		copy: {
			deploy: {
				files: [
					{expand: true, src: ['assets/img/*'], dest: 'www/', filter: 'isFile'}
				]
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-jade');
	grunt.loadNpmTasks('grunt-contrib-sass');
	grunt.loadNpmTasks('grunt-contrib-copy');

	grunt.registerTask('default', ['sass:dist', 'uglify:dist', 'jade:dist']);
	grunt.registerTask('dev', ['sass:dist', 'jade:dev']);
	grunt.registerTask('deploy', [
		'sass:deploy',
		'uglify:deploy',
		'jade:deploy',
		'copy:deploy',
	]);
};
