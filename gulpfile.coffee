
# Load libs
gulp       = require 'gulp'
del        = require 'del'
browserify = require 'browserify'
watchify   = require 'watchify'
buffer     = require 'vinyl-buffer'
source     = require 'vinyl-source-stream'
runSeq     = require 'run-sequence'
wiredep    = require 'wiredep'
merge      = require 'merge-stream'
karma      = require('karma').server

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


# Helpers

bundler = (watch = false)->
  # Create bundler
  b = browserify
    entries: paths.entries
    debug: not config.production
    extensions: ['.coffee']

  # Wrap in watchify if watching
  b = watchify b, watchify.args if watch

  # Apply browserify transforms
  b.transform 'coffeeify'
  b

bundle = (b)->
  b.bundle()
    .on 'error', $.util.log.bind($.util, "Browserify Error")
    .pipe source('app.js')
    .pipe buffer()
    .pipe $.if(config.production, $.uglify())
    .pipe gulp.dest("#{base.dist}/scripts")


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
  bundle bundler()

gulp.task 'styles', ->
  gulp.src paths.styles, cwd: base.app
    .pipe $.rubySass(
      style: 'expanded'
      loadPath: ['bower_components']
    )
    .pipe $.autoprefixer('last 2 version')
    .pipe $.if(config.production, $.minifyCss())
    .pipe gulp.dest("#{base.dist}/styles")

gulp.task 'vendor', ->
  jsStream = gulp.src wiredep().js
    .pipe $.concat('vendor.js')
    .pipe $.if(config.production, $.uglify())
    .pipe gulp.dest("#{base.dist}/scripts")

  cssStream = gulp.src wiredep(
    exclude: ['bootstrap-sass-official']
  ).css
    .pipe $.concat('vendor.css')
    .pipe $.if(config.production, $.minifyCss())
    .pipe gulp.dest("#{base.dist}/styles")

  merge(jsStream, cssStream)

gulp.task 'images', ->
  gulp.src paths.images, cwd: base.app
    .pipe $.cache($.imagemin(
      optimizationLevel: 3,
      progressive: true,
      interlaced: true
    ))
    .pipe gulp.dest("#{base.dist}/images")

gulp.task 'html', ->
  gulp.src paths.html, cwd: base.app
    .pipe gulp.dest(base.dist)

gulp.task 'copy-extras', ->
  gulp.src paths.extras, cwd: base.app
    .pipe gulp.dest(base.dist)

gulp.task 'test', (cb)->
  karma.start
    configFile: "#{__dirname}/karma.conf.coffee"
  , cb

gulp.task 'serve', ->
  gulp.src base.dist
    .pipe $.webserver(
      livereload: true
      port: 9000
    )

gulp.task 'watch', ['serve'], ->
  # Watch scripts with watchify
  b = bundler(true)
  b.on 'update', ->
    $.util.log "Starting re-bundling scripts"
    bundle(b).on 'end', -> $.util.log("Finished re-bundling scripts")

  # Watch other files
  gulp.watch "#{base.app}/#{paths.styles}" , ['styles']
  gulp.watch "#{base.app}/#{paths.images}" , ['images']
  gulp.watch "#{base.app}/#{paths.html}"   , ['html']


gulp.task 'build', (cb)->
  runSeq 'clean',
         ['scripts', 'styles', 'vendor', 'images', 'html', 'copy-extras'],
         cb

gulp.task 'dev', ['set-development', 'default']

gulp.task 'default', ['build'], ->
  gulp.start 'watch'


