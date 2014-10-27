
React = require 'react/addons'
TestUtils = React.addons.TestUtils

MediaQueries = require '../../../app/scripts/utils/MediaQueries'


describe MediaQueries, ->

  describe '._buildMinQuery', ->

    it 'should return the correct media query for min width', ->
      expect(MediaQueries._buildMinQuery(5)).toEqual '(min-width: 5px)'
      expect(MediaQueries._buildMinQuery(0)).toEqual '(min-width: 0px)'


