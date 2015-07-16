
# Load libs
extend     = require 'extend'
request    = require 'request'
fs         = require 'fs'
jf         = require 'jsonfile'
gulp       = require 'gulp'
del        = require 'del'
browserify = require 'browserify'
watchify   = require 'watchify'
buffer     = require 'vinyl-buffer'
source     = require 'vinyl-source-stream'
runSeq     = require 'run-sequence'
through    = require 'through2'
wiredep    = require 'wiredep'
merge      = require 'merge-stream'
bowerFiles = require 'main-bower-files'
envify     = require 'envify/custom'
cfdists    = require './.cfdists.json'
auth       = require './.auth.json'
env        = require './.env.json'
karma      = require('karma').server

# Load plugins
$ = require('gulp-load-plugins')()


# Set vars
jf.spaces = 2


# Env
env.APP_ENV = if $.util.env.dev is true
  "development"
else if $.util.env.test is true
  "test"
else if $.util.env.staging is true
  "staging"
else
  "production"

env[env.APP_ENV].CLOSED = $.util.env.close

config =
  production: env.APP_ENV is "production"
  school: $.util.env.school


# Deploy Vars
config.domain = if config.production
  "#{config.school}.academical.co"
else
  "#{config.school}-staging.academical.co"


# Paths
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
  distEnv = extend {}, env[env.APP_ENV], SCHOOL: env.SCHOOL,APP_ENV: env.APP_ENV
  b = browserify
    entries: "#{base.app}/#{paths.main.script}"
    debug: not config.production
    extensions: ['.coffee']

  # Wrap in watchify if watching
  b = watchify b, watchify.args if watch

  # Apply browserify transforms
  b.transform 'coffeeify'
  b.transform 'browserify-shim'
  b.transform envify(distEnv)
  b

bundle = (b)->
  b.bundle()
    .on 'error', $.util.log.bind($.util, "Browserify Error")
    .pipe source('app.js')
    .pipe buffer()
    .pipe $.if(config.production, $.uglify())
    .pipe gulp.dest("#{base.dist}/scripts")

s3WebUpdate = (publisher)->
  s3      = publisher.client
  indexRe = /^index\.[a-f0-9]{8}\.html(\.gz)*$/gi

  through.obj (file, enc, cb)->
    return if not file.path?
    dirRoot  = file.base
    fname    = file.path.substr dirRoot.length
    if fname.match indexRe
      params =
        WebsiteConfiguration:
          IndexDocument:
            Suffix: fname
      s3.putBucketWebsite params, (err, response)->
        if err?
          $.util.log new $.util.PluginError('s3-web-update', err)
          cb null, file
          return
        else
          cb null, file
    else
      cb null, file


# Tasks
gulp.task 'clear-school', ->
  delete env.SCHOOL
  jf.writeFileSync './.env.json', env

# TODO remove clear-school
gulp.task 'fetch-school', ['clear-school'], (cb)->
  nickname = config.school
  $.util.log "School: ", $.util.colors.cyan("#{nickname}")

  if not env.SCHOOL? or env.SCHOOL.nickname != nickname
    appEnv  = env[env.APP_ENV]
    options =
      url: "#{appEnv.API_PROTOCOL}://#{appEnv.API_HOST}/schools/#{nickname}"
      json: true
      qs: {camelize: true}
      headers:
        "Authorization": "Bearer #{auth[env.APP_ENV]}"
    request.get options, (error, response, body)->
      if error?
        throw error
      else if response.statusCode != 200
        throw new Error "Could not fetch school #{nickname}: "+body.message
      else
        env.SCHOOL = body.data
        jf.writeFileSync './.env.json', env

gulp.task 'clean', (cb)->
  del base.dist, cb

gulp.task 'lint', ->
  gulp.src paths.scripts, cwd: base.app
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()

gulp.task 'scripts', ['lint', 'fetch-school'], ->
  bundle bundler()

gulp.task 'styles', ->
  $.rubySass(base.app + "/" + paths.main.style[0],
      style: 'compact'
      loadPath: ['bower_components']
      bundleExec: true
      sourcemap: true
    )
    .on 'error', $.util.log.bind($.util, "Sass Error")
    .pipe $.autoprefixer()
    .pipe $.if((not config.production), $.sourcemaps.write())
    .pipe $.if(config.production, $.minifyCss())
    .pipe gulp.dest("#{base.dist}/styles")

gulp.task 'vendor', ->
  jsDeps = wiredep().js

  cssDeps = wiredep(
    exclude: ['bootstrap-sass-official', 'font-awesome']
  ).css

  jsStream = gulp.src jsDeps
    .pipe $.concat('vendor.js')
    .pipe $.if(config.production, $.uglify())
    .pipe gulp.dest("#{base.dist}/scripts")

  cssStream = gulp.src cssDeps
    .pipe $.concat('vendor.css')
    .pipe $.if(config.production, $.minifyCss())
    .pipe gulp.dest("#{base.dist}/styles")

  merge(jsStream, cssStream)

gulp.task 'fonts', ->
  gulp.src bowerFiles()
    .pipe $.filter('**/*.{eot,svg,ttf,woff,woff2}')
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
  analyticsIds = require './.analytics.json'
  gulp.src paths.html, cwd: base.app
    .pipe($.mustache(analyticsIds[config.school]))
    .pipe gulp.dest(base.dist)

gulp.task 'copy-extras', ->
  gulp.src paths.extras, cwd: base.app
    .pipe gulp.dest(base.dist)

gulp.task 'test', (cb)->
  env.APP_ENV = "test"
  karma.start
    configFile: "#{__dirname}/karma.conf.coffee"
  , cb

gulp.task 'server', ->
  gulp.src base.dist
    .pipe $.webserver(
      livereload: true
      port: 9000
      host: "0.0.0.0"
      fallback: 'index.html'
    )

gulp.task 'watch', ['server'], ->
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
  tasks = ['scripts', 'styles', 'vendor', 'fonts', 'images', 'html', 'copy-extras']
  runSeq 'clean', tasks, cb

gulp.task 'serve', ['build'], ->
  gulp.start 'watch'

gulp.task 'deploy-aws', ['build'], ->
  opts =
    Bucket: config.domain
    region: "us-standard"
    distributionId: cfdists[config.school][env.APP_ENV]

  publisher = $.awspublish.create params: opts
  headers   = {'Cache-Control': 'max-age=315360000, no-transform, public'}
  headers["x-amz-acl"] = 'private' if config.production

  revAll = new $.revAll()
  gulp.src "#{base.dist}/**"
    .pipe revAll.revision()
    .pipe $.awspublish.gzip()
    .pipe publisher.publish(headers)
    .pipe publisher.cache()
    .pipe $.awspublish.reporter()
    .pipe $.cloudfront(opts)
    .pipe publisher.sync()
    .pipe $.if(not config.production, s3WebUpdate(publisher))

gulp.task 'default', ['build']
