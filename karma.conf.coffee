#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# Karma configuration
# Generated on Mon Oct 20 2014 17:00:17 GMT-0400 (EDT)
extend = require 'extend'
env    = require './.env.json'
env    = extend {}, env["test"], SCHOOL: env.SCHOOL, APP_ENV: "test"

module.exports = (config) ->
  config.set

    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: ''

    # timeouts
    browserNoActivityTimeout: 15000

    # frameworks to use
    # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['browserify', 'jasmine-ajax', 'jasmine']

    # Proxy to serve statis assets
    proxies: {
      '/images/': 'http://localhost:9876/base/dist/images/'
    },

    # list of files / patterns to load in the browser
    files: [
      {pattern: 'dist/images/**/*.png', watched: false, included: false, served: true}
      'dist/scripts/vendor.js'
      'test/shims/*.{js,coffee}'
      'test/SpecHelper.coffee'
      'test/shared/**/*.coffee'
      'test/spec/**/*.spec.coffee'
    ]


    # list of files to exclude
    exclude: [
    ]


    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      'test/SpecHelper.coffee': ['browserify']
      'test/**/*.coffee': ['browserify']
    }


    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['dots']


    # web server port
    port: 9876


    # enable / disable colors in the output (reporters and logs)
    colors: true


    # level of logging
    # possible values:
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO


    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true


    # start these browsers
    # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['Chrome']


    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: false

    browserify: {
      bundleDelay: 1500
      extensions: ['.coffee']
      debug: true
      transform: [
        'coffeeify'
        'browserify-shim'
        ['envify', env]
        ['rewireify', {
            ignore: "I18nMixin.coffee,ItemMixin.coffee,IconMixin.coffee,ModalMixin.coffee,SpinnerMixin.coffee,FormMixin.coffee"
          }
        ]
      ]
    }


