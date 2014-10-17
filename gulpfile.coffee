
# Load libs
gulp       = require 'gulp'
del        = require 'del'
browserify = require 'browserify'
buffer     = require 'vinyl-buffer'
source     = require 'vinyl-source-stream'

# Load plugins
$ = require('gulp-load-plugins')()


# Set vars
config =
  production: true

base =
  app: './app/'
  dist: './dist/'

paths =
  entries: ["#{base.app}scripts/app.coffee"]
  scripts: ['scripts/**/*.coffee']
  styles: ['styles/**/*.scss']
  images: ['images/**/*']
  html: ['index.html']

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
  del base.dist, cb

gulp.task 'lint', ->
  gulp.src paths.scripts, cwd: base.app
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()

gulp.task 'scripts', ['clean', 'lint'], ->
  bundler = browserify
    entries: paths.entries
    debug: not config.production

  bundler
    .transform 'coffeeify'
    .bundle()
    .pipe source(bundleName())
    .pipe buffer()
    .pipe $.if(config.production, $.uglify())
    .pipe gulp.dest("#{base.dist}/scripts")

gulp.task 'dev', ['set-development', 'default']

gulp.task 'default', ['scripts']


