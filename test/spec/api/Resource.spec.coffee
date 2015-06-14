
H            = require '../../SpecHelper'
Resource     = require '../../../app/scripts/api/Resource'
RequestError = require '../../../app/scripts/errors/RequestError'
Academical   = require '../../../app/scripts/api/Academical'


describe 'Resource', ->

  describe "#constructor", ->

    beforeEach ->
      @api = new Academical {}

      @basePath        = @api.get "basePath"
      @urlInterpolator = H.spy("urlInterpolator").and.callFake (path)-> path
      @restore         = H.rewire Resource,
        "Url.makeUrlInterpolator": @urlInterpolator

    afterEach ->
      @restore()

    it 'inits base path correctly', ->
      res = new Resource @api
      expect(@urlInterpolator).toHaveBeenCalledWith @basePath
      expect(res.basePath).toEqual @basePath

    it 'inits path correctly when provided', ->
      class Res1 extends Resource
        path: "resources"

      res = new Res1 @api
      expect(@urlInterpolator.calls.mostRecent().args[0]).toEqual "resources"
      expect(res.path).toEqual "resources"

    it 'inits path correctly when not provided', ->
      res = new Resource @api
      expect(@urlInterpolator.calls.count()).toEqual 1
      expect(res.path).toEqual ""


  describe '._responseHandler', ->

    beforeEach ->
      @cb       = H.spy "cb"
      @handler  = Resource._responseHandler @cb

    it 'passes correct data to callback when request succeeds', ->
      response = body: {data: {f1: 1, f2: 2}, success: true}
      @handler null, response
      expect(@cb).toHaveBeenCalledWith null, f1: 1, f2: 2

    it 'throws correct error when a connection error occurs', ->
      err = message: "Some connection error"
      @handler err, null
      expect(@cb).toHaveBeenCalledWith H.any(RequestError), null
      expect(@cb.calls.mostRecent().args[0].message).toEqual "Connection Error
      - Some connection error"

    it 'throws correct error when api error in response occurs', ->
      response =
        error: message: "Incorrect!"
        status: 503
        body: {message: "Wrong", success: false}
      @handler null, response
      expect(@cb).toHaveBeenCalledWith H.any(RequestError), "Wrong"
      expect(@cb.calls.mostRecent().args[0].message).toEqual(
        "API Error - Incorrect!\nResponse Status: 503\nAPI Message: Wrong"
      )


  describe '._formatRequestData', ->

    beforeEach ->
      @reqData = fieldOne: 1, fieldTwo: 2

    describe 'when not GETing', ->

      it 'returns correct request data when not wrapped in "data" key', ->
        result  = Resource._formatRequestData "post", @reqData
        expect(result).toEqual data: {field_one: 1, field_two: 2}, camelize: true

      it 'returns correct request data when wrapped in "data" key', ->
        result  = Resource._formatRequestData "post", data: @reqData
        expect(result).toEqual data: {field_one: 1, field_two: 2}, camelize: true

      it 'includes provided "params" outside of "data" key wrap', ->
        result  = Resource._formatRequestData "post", data: @reqData, params:g:5
        expect(result).toEqual
          data: {field_one: 1, field_two: 2}, camelize: true, g: 5

    it 'returns correct request data (as is) when GETing', ->
      result  = Resource._formatRequestData "get", @reqData
      expect(result).toEqual field_one: 1, field_two: 2, camelize: true

    it 'returns correct request data with additional params', ->
      @reqData.params = g: 5
      result  = Resource._formatRequestData "get", @reqData
      expect(result).toEqual field_one: 1, field_two: 2, camelize: true, g: 5

    it 'returns correct request data when no data given', ->
      result  = Resource._formatRequestData "get"
      expect(result).toEqual camelize: true
      result  = Resource._formatRequestData "post"
      expect(result).toEqual camelize: true


  describe '.createApiCall', ->

    beforeEach ->
      H.ajax.install()
      @api = new Academical {}
      @res = new Resource @api
      @cb = H.spy "cb"
      @res.call = Resource.createApiCall
        method: "get"
        path: "call/path/{p1}"
        requiredParams: ["p1"]

    afterEach ->
      H.ajax.uninstall()

    it 'throws error when callback not provided', ->
      @res.call = Resource.createApiCall method: "get"
      expect(->@res.call()).toThrowError()

    it 'throws error when request fails', ->
      @res.call "param1", @cb
      H.ajax.fail 500, "Oops!"
      expect(@cb).toHaveBeenCalledWith H.any(RequestError), "Oops!"
      e = @cb.calls.mostRecent().args[0]
      expect(e.apiMsg).toEqual "Oops!"

    describe 'when sending a "get" request', ->

      it 'sends correct request, query string data and calls callback', ->
        @res.call "param1", {count: true}, @cb
        H.ajax.assertRequest(
          "get"
          @api.get "host"
          @api.get "protocol"
          "/call/path/param1"
          data: {count: true}
        )
        H.ajax.succeed f1: 1, f2: 2
        expect(@cb).toHaveBeenCalledWith null, f1: 1, f2:2

      it 'sends correct request without data and calls callback', ->
        @res.call "param1", @cb
        H.ajax.assertRequest(
          "get"
          @api.get "host"
          @api.get "protocol"
          "/call/path/param1"
        )
        H.ajax.succeed f1: 1, f2: 2
        expect(@cb).toHaveBeenCalledWith null, f1: 1, f2:2

    describe 'when sending a request different from "get"', ->

      beforeEach ->
        @res.call = Resource.createApiCall
          method: "post"
          path: "call/path/{p1}"
          requiredParams: ["p1"]

      it 'sends correct request, data in body and calls callback', ->
        @res.call "param1", {count: true}, @cb
        H.ajax.assertRequest(
          "post"
          @api.get "host"
          @api.get "protocol"
          "/call/path/param1"
          data: {count: true}
        )
        H.ajax.succeed f1: 1, f2: 2
        expect(@cb).toHaveBeenCalledWith null, f1: 1, f2:2

      it 'sends correct request without data and calls callback', ->
        @res.call "param1", @cb
        H.ajax.assertRequest(
          "post"
          @api.get "host"
          @api.get "protocol"
          "/call/path/param1"
        )
        H.ajax.succeed f1: 1, f2: 2
        expect(@cb).toHaveBeenCalledWith null, f1: 1, f2:2

