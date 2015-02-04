
H   = require '../../SpecHelper'
Url = require '../../../app/scripts/api/Url'


describe 'Url', ->

  describe '.fullUrl', ->

    beforeEach ->
      H.spyOn(Url, "makeUrlInterpolator").and.callFake (path)-> ->path
      @protocol = "https"

    it 'returns fullUrl correctly when all paths are strings', ->
      [p1, p2, p3, p4] = ["p1.com", "/", "p2", "p3"]
      url = Url.fullUrl @protocol, p1, p2, p3, p4, {}

      expect(url).toEqual "https://p1.com/p2/p3"
      expect(Url.makeUrlInterpolator.calls.count()).toEqual 4

    it 'returns fullUrl correctly when functions provided too', ->
      p1 = "p1.com"
      p2 = ()-> "/v1/"
      p3 = "schools"
      url = Url.fullUrl @protocol, p1, p2, p3, {}

      expect(url).toEqual "https://p1.com/v1/schools"
      expect(Url.makeUrlInterpolator.calls.count()).toEqual 2

    it 'throws error when args are not strings', ->
      p1 = "p1.com"
      p2 = ()-> "/v1/"
      p3 = 5
      expect(->Url.fullUrl @protocol, p1, p2, p3, {}).toThrowError()

    it 'throws error when args are not functions that return strings', ->
      p1 = "p1.com"
      p2 = ()-> 5
      p3 = "5"
      expect(->Url.fullUrl @protocol, p1, p2, p3, {}).toThrowError()


  describe '.getUrlParamsObj', ->

    it 'returns correct object of url params when args are correct', ->
      required = ["v1", "v2", "v3"]
      values   = ["1", "2", "3"]

      obj = Url.getUrlParamsObj required, values
      expect(obj).toEqual v1: "1", v2: "2", v3: "3"

    it 'throws error when one of the values is null or undefined', ->
      required = ["v1", "v2", "v3"]
      values   = ["1", null, "3"]
      expect(->Url.getUrlParamsObj(required, values)).toThrowError()

      required = ["v1", "v2", "v3"]
      values   = ["1", undefined, "3"]
      expect(->Url.getUrlParamsObj(required, values)).toThrowError()

    it 'throws error when values are missing for requiredKeys', ->
      required = ["id", "schoolId"]
      values   = ["544bc"]
      expect(->Url.getUrlParamsObj(required, values)).toThrowError()

    it 'throws error when there are more values than requiredKeys', ->
      required = ["id"]
      values   = ["544bc", "445cb"]
      expect(->Url.getUrlParamsObj(required, values)).toThrowError()

