
# Set config
config =
  production: true

# Load libs
gulp       = require 'gulp'
browserify = require 'browserify'
buffer     = require 'vinyl-buffer'
source     = require 'vinyl-source-stream'

# Load plugins
$ = require('gulp-load-plugins')()


gulp.task 'set-development', ->
  config.production = false

gulp.task 'clean', (cb)->
  del './dist/', cb

gulp.task 'lint', ->
  gulp.src './app/**/*.coffee'
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()

gulp.task 'browserify', ['lint'], ->
  bundler = browserify
    entries: './app/scripts/app.coffee'
    debug: not config.production

  s = bundler
    .transform 'coffeeify'
    .bundle()
    .pipe source('app.js')
    .pipe buffer()

  s = s.pipe $.uglify() if config.production

  s.pipe gulp.dest('./dist/scripts/')
  s

gulp.task 'scripts', ['browserify']

gulp.task 'dev', ['set-development', 'default']

gulp.task 'default', ['scripts']


