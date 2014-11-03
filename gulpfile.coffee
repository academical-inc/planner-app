
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
bowerFiles = require 'main-bower-files'
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
  main:
    script: ['scripts/app.coffee']
    style: ['styles/main.scss']
  scripts: ['scripts/**/*.coffee']
  styles: ['styles/**/*.scss']
  images: ['images/**/*']
  html: ['index.html']
  extras: ['*.*', '!*.html']


# Helpers

bundler = (watch = false)->
  # Create bundler
  b = browserify
    entries: "#{base.app}/#{paths.main.script}"
    debug: not config.production
    extensions: ['.coffee']

  # Wrap in watchify if watching
  b = watchify b, watchify.args if watch

  # Apply browserify transforms
  b.transform 'coffeeify'
  b.transform 'browserify-shim'
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
  gulp.src paths.main.style, cwd: base.app
    .pipe $.rubySass(
      style: 'expanded'
      loadPath: ['bower_components']
      bundleExec: true
    )
    .on 'error', $.util.log.bind($.util, "Sass Error")
    .pipe $.autoprefixer('last 2 version')
    .pipe $.if(config.production, $.minifyCss())
    .pipe gulp.dest("#{base.dist}/styles")

gulp.task 'vendor', ->
  jsDeps = wiredep(
    exclude: ['font-awesome']
  )
  cssDeps = wiredep(
    exclude: ['bootstrap-sass-official', 'font-awesome']
  )

  jsStream = gulp.src jsDeps.js
    .pipe $.concat('vendor.js')
    .pipe $.if(config.production, $.uglify())
    .pipe gulp.dest("#{base.dist}/scripts")

  cssStream = gulp.src cssDeps.css
    .pipe $.concat('vendor.css')
    .pipe $.if(config.production, $.minifyCss())
    .pipe gulp.dest("#{base.dist}/styles")

  merge(jsStream, cssStream)

gulp.task 'fonts', ->
  gulp.src bowerFiles()
    .pipe $.filter('bower_components/font-awesome/**/*.{eot,svg,ttf,woff}')
    .pipe $.flatten()
    .pipe gulp.dest("#{base.dist}/styles/fonts")

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
      host: "0.0.0.0"
    )

gulp.task 'watch', ['serve'], ->
  # Watch scripts with watchify
  b = bundler(true)
  b.on 'update', ->
    $.util.log "Starting", $.util.colors.cyan("'re-bundling scripts'")
    bundle(b).on 'end', ->
      $.util.log "Finished", $.util.colors.cyan("'re-bundling scripts'")
  bundle(b)

  # Watch other files
  gulp.watch "#{base.app}/#{paths.styles}" , ['styles']
  gulp.watch "#{base.app}/#{paths.images}" , ['images']
  gulp.watch "#{base.app}/#{paths.html}"   , ['html']

  # Watch bower.json
  gulp.watch "./bower.json", ['vendor', 'fonts']


gulp.task 'build', (cb)->
  runSeq 'clean',
         ['scripts', 'styles', 'vendor', 'fonts', 'images', 'html', 'copy-extras'],
         cb

gulp.task 'dev', ['set-development', 'default']

gulp.task 'default', ['build'], ->
  gulp.start 'watch'


