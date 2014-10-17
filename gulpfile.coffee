
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
  styles: ['styles/main.scss']
  images: ['images/**/*']
  html: ['index.html']


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
    .pipe source('app.js')
    .pipe buffer()
    .pipe $.if(config.production, $.uglify())
    .pipe gulp.dest("#{base.dist}/scripts")

gulp.task 'styles', ['clean'], ->
  gulp.src paths.styles, cwd: base.app
    .pipe $.rubySass(
      style: 'expanded'
      loadPath: ['bower_components']
    )
    .pipe $.autoprefixer('last 2 version')
    .pipe $.if(config.production, $.minifyCss())
    .pipe gulp.dest("#{base.dist}/styles")

gulp.task 'images', ['clean'], ->
  gulp.src('app/images/**/*')
    .pipe $.cache($.imagemin(
      optimizationLevel: 3,
      progressive: true,
      interlaced: true
    ))
    .pipe gulp.dest('dist/images')

gulp.task 'dev', ['set-development', 'default']

gulp.task 'default', ['scripts', 'styles', 'images']


