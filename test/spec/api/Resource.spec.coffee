
H          = require '../../SpecHelper'
Resource   = require '../../../app/scripts/api/Resource'
Academical = require '../../../app/scripts/api/Academical'


describe 'Resource', ->

  beforeEach ->
    @api = new Academical {}
    @api.setBasePath "/"
    @api.setHeaders  {h1: "h1"}
    @api.setTimeout  120000
    @api.setHost     "host.com", 80, "http"

    @urlInterpolator = H.spy("urlInterpolator").and.callFake (path)-> path
    @restore = H.rewire Resource,
      "Url.makeUrlInterpolator": @urlInterpolator

  afterEach ->
    @restore()

  describe "#constructor", ->

    it 'inits base path correctly', ->
      res = new Resource @api
      expect(@urlInterpolator).toHaveBeenCalledWith "/"
      expect(res.basePath).toEqual @api.get("basePath")

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


  xdescribe '#createApiCall', ->

    beforeEach ->
      @res = new Resource @api

      callSpec =
        method: "get"
        path: "call/path/{p1}"
        requiredParams: ["p1"]
      @res.call = Resource.createApiCall callSpec

    it "creates correct api call when", ->

