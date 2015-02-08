
H          = require '../../SpecHelper'
Academical = require '../../../app/scripts/api/Academical'


describe 'Academical', ->

  describe '#constructor', ->

    it 'inits resources correctly', ->
      Res1 = H.spy "Res1"
      Res2 = H.spy "Res2"
      resMap =
        Res1: Res1
        Res2: Res2
      api = new Academical(resMap)
      expect(Res1).toHaveBeenCalledWith api
      expect(Res2).toHaveBeenCalledWith api
      expect(api.res1).toEqual H.any(Res1)
      expect(api.res2).toEqual H.any(Res2)

    it 'assigns defaults correctly', ->
      api = new Academical {}
      expect(api.get("host")).toEqual Academical.DEFAULT_HOST
      expect(api.get("protocol")).toEqual Academical.DEFAULT_PROTOCOL
      expect(api.get("basePath")).toEqual Academical.DEFAULT_BASE_PATH
      expect(api.get("timeout")).toEqual Academical.DEFAULT_TIMEOUT
      expect(api.get("headers")).toEqual Academical.DEFAULT_HEADERS
