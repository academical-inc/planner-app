
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
      expect(api.res1).toEqual jasmine.any(Res1)
      expect(api.res2).toEqual jasmine.any(Res2)

