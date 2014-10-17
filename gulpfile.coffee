
# Set config
config =
  production: true

# Load libs
gulp       = require 'gulp'
del        = require 'del'
browserify = require 'browserify'
buffer     = require 'vinyl-buffer'
source     = require 'vinyl-source-stream'

# Load plugins
$ = require('gulp-load-plugins')()


# Helpers

bundleName = ->
  if config.production
    'app.min.js'
  else
    'app.js'


# Tasks

gulp.task 'set-development', ->
  config.production = false

gulp.task 'clean', (cb)->
  del './dist/', cb

gulp.task 'lint', ->
  gulp.src './app/**/*.coffee'
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()

gulp.task 'scripts', ['clean', 'lint'], ->
  bundler = browserify
    entries: './app/scripts/app.coffee'
    debug: not config.production

  bundler
    .transform 'coffeeify'
    .bundle()
    .pipe source(bundleName())
    .pipe buffer()
    .pipe $.if(config.production, $.uglify())
    .pipe gulp.dest('./dist/scripts/')

gulp.task 'dev', ['set-development', 'default']

gulp.task 'default', ['scripts']


