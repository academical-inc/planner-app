
# Load libs
gulp       = require 'gulp'
del        = require 'del'
browserify = require 'browserify'
buffer     = require 'vinyl-buffer'
source     = require 'vinyl-source-stream'
runSeq     = require 'run-sequence'
wiredep    = require 'wiredep'

# Load plugins
$ = require('gulp-load-plugins')()


# Set vars
config =
  production: true

base =
  app: './app'
  dist: './dist'

paths =
  entries: ["#{base.app}/scripts/app.coffee"]
  scripts: ['scripts/**/*.coffee']
  styles: ['styles/main.scss']
  images: ['images/**/*']
  html: ['index.html']
  extras: ['*.*', '!*.html']


# Tasks
gulp.task 'set-development', ->
  config.production = false

gulp.task 'clean', (cb)->
  del base.dist, cb

gulp.task 'lint', ->
  gulp.src paths.scripts, cwd: base.app
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()

gulp.task 'scripts', ['lint'], ->
  bundler = browserify
    entries: paths.entries
    debug: not config.production
    extensions: ['.coffee']

  bundler
    .transform 'coffeeify'
    .bundle()
    .pipe source('app.js')
    .pipe buffer()
    .pipe $.if(config.production, $.uglify())
    .pipe gulp.dest("#{base.dist}/scripts")

gulp.task 'styles', ->
  gulp.src paths.styles, cwd: base.app
    .pipe $.rubySass(
      style: 'expanded'
      loadPath: ['bower_components']
    )
    .pipe $.autoprefixer('last 2 version')
    .pipe $.if(config.production, $.minifyCss())
    .pipe gulp.dest("#{base.dist}/styles")

gulp.task 'images', ->
  gulp.src paths.images, cwd: base.app
    .pipe $.cache($.imagemin(
      optimizationLevel: 3,
      progressive: true,
      interlaced: true
    ))
    .pipe gulp.dest("#{base.dist}/images")

gulp.task 'html', ->
  # TODO Should probably inject bower dependencies here somehow
  gulp.src "#{base.app}/#{paths.html}"
    .pipe wiredep.stream(
      exclude: ['bootstrap-sass-official']
    )
    .pipe gulp.dest(base.dist)

gulp.task 'copy-extras', ->
  gulp.src paths.extras, cwd: base.app
    .pipe gulp.dest(base.dist)

gulp.task 'serve', ->
  gulp.src base.dist
    .pipe $.webserver(
      livereload: true
      port: 9000
    )

gulp.task 'watch', ['serve'], ->
  gulp.watch "#{base.app}/#{paths.scripts}", ['scripts']
  gulp.watch "#{base.app}/#{paths.styles}" , ['styles']
  gulp.watch "#{base.app}/#{paths.images}" , ['images']
  gulp.watch "#{base.app}/#{paths.html}"   , ['html']


gulp.task 'build', (cb)->
  runSeq 'clean',
         ['scripts', 'styles', 'images', 'html', 'copy-extras'],
         cb

gulp.task 'dev', ['set-development', 'default']

gulp.task 'default', ['build'], ->
  gulp.start 'watch'


