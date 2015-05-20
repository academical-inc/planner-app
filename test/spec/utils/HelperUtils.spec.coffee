
H = require '../../SpecHelper'
_ = require '../../../app/scripts/utils/HelperUtils'


describe 'HelperUtils', ->

  beforeEach ->
    @arr = ["some", 34, 5, {thing: "5"}, 34]

  describe '.find', ->

    it 'finds and returns correct value', ->
      res = _.find @arr, (datum)-> datum.thing is "5"
      expect(res).toEqual thing: "5"
      res = _.find @arr, (datum)-> datum is 34
      expect(res).toEqual 34

    it 'returns null if value is not found', ->
      res = _.find @arr, (datum)-> datum is "poof"
      expect(res).toBeNull()

    it 'returns null if array is empty', ->
      res = _.find [], (datum)-> datum is "poof"
      expect(res).toBeNull()


  describe '.findWithIdx', ->

    it 'finds and returns correct value with index', ->
      [res, idx] = _.findWithIdx @arr, (datum)-> datum.thing is "5"
      expect(res).toEqual thing: "5"
      expect(idx).toEqual 3
      [res, idx] = _.findWithIdx @arr, (datum)-> datum is 34
      expect(res).toEqual 34
      expect(idx).toEqual 1

    it 'returns null if value is not found', ->
      [res, idx] = _.findWithIdx @arr, (datum)-> datum is "poof"
      expect(res).toBeNull()
      expect(idx).toBeNull()

    it 'returns null if array is empty', ->
      [res, idx] = _.findWithIdx [], (datum)-> datum is "poof"
      expect(res).toBeNull()
      expect(idx).toBeNull()

  describe '.removeAt', ->

    it 'removes element at specified index and modifies original array', ->
      removed = _.removeAt @arr, 3
      expect(removed).toEqual thing: "5"
      expect(@arr).toEqual ["some", 34, 5, 34]

    it 'does nothing when index is null', ->
      removed = _.removeAt @arr, null
      expect(removed).toBeNull()
      expect(@arr).toEqual ["some", 34, 5, {thing: "5"}, 34]

    it 'does nothing when index does not exist', ->
      removed = _.removeAt @arr, 5
      expect(removed).toBeNull()
      expect(@arr).toEqual ["some", 34, 5, {thing: "5"}, 34]

  describe '.findAndRemove', ->

    it 'removes and returns first found element', ->
      removed = _.findAndRemove @arr, (datum)-> datum is 34
      expect(removed).toEqual 34
      expect(@arr).toEqual ["some", 5, {thing: "5"}, 34]

    it 'returns null and does nothing if element does not exist', ->
      removed = _.findAndRemove @arr, (datum)-> datum is "poof"
      expect(removed).toBeNull()
      expect(@arr).toEqual ["some", 34, 5, {thing: "5"}, 34]

  describe '.getNested', ->

    beforeEach ->
      @obj = k: {k1: 1, j: {k3: 3}}, k2: 2

    it 'gets value for nested key', ->
      expect(_.getNested(@obj, "k.k1")).toEqual 1
      expect(_.getNested(@obj, "k.j.k3")).toEqual 3

    it 'gets value for normal key', ->
      expect(_.getNested(@obj, "k2")).toEqual 2

    it 'gets value for key when value is null or undefined', ->
      @obj.k2 = undefined
      @obj.k.k1 = null
      @obj.k.j.k3 = null
      expect(_.getNested(@obj, "k2")).toEqual undefined
      expect(_.getNested(@obj, "k.k1")).toEqual null
      expect(_.getNested(@obj, "k.j.k3")).toEqual null

    it 'returns null if key not found', ->
      expect(_.getNested(@obj, "k.k2.k5")).toBe null
      expect(_.getNested(@obj, "k.k2")).toBe null
      expect(_.getNested(@obj, "k3")).toBe null

  describe '.setNested', ->

    beforeEach ->
      @obj = k: {k1: 1, j: {k3: 3}}, k2: 2

    it 'should set value when key exists', ->
      _.setNested @obj, "k.k1", 100
      expect(_.getNested(@obj, "k.k1")).toEqual 100

    it 'should set value when key does not exist', ->
      _.setNested @obj, "k.k4.k5", 100
      expect(_.getNested(@obj, "k.k4.k5")).toEqual 100

  describe '.objInclude', ->

    beforeEach ->
      @obj = k1: 1, k3: 3

    it 'filters obj correctly when keys to include is array', ->
      keys = ["k1", "k2"]
      expect(_.objInclude(@obj, keys)).toEqual k1: 1

    it 'filters obj correctly when keys to include is object', ->
      keys = k1: null, k2: null
      expect(_.objInclude(@obj, keys)).toEqual k1: 1

    it 'filters obj correctly when keys are nested', ->
      @obj.k1 = {k4: 4, k5: 5}
      @obj.k2 = 2
      keys = ["k1.k4", "k2"]
      expect(_.objInclude(@obj, keys)).toEqual k1: {k4: 4}, k2: 2

    it 'filters obj correctly when keys have null values', ->
      @obj.k1 = {k4: undefined, k5: 5}
      @obj.k2 = null
      keys = ["k1.k4", "k2"]
      expect(_.objInclude(@obj, keys)).toEqual k1: {k4: undefined}, k2: null

    describe 'when defaults present', ->

      it 'filters obj correctly when defaults are values', ->
        keys = k1: null, k2: 2
        expect(_.objInclude(@obj, keys)).toEqual k1: 1, k2: 2

      it 'filters obj correctly when defaults are functions', ->
        defFunc = H.spy "defFunc", retVal: 2
        keys = k1: null, k2: defFunc
        expect(_.objInclude(@obj, keys)).toEqual k1: 1, k2: 2
        expect(defFunc).toHaveBeenCalledWith @obj

      it 'filters obj correctly when nested defaults', ->
        @obj.kN = {kN1: "n1", kN2: "n2"}
        keys = k1: null, "kN.kN1": "defN1", "kN.kN3": "defN3"
        expect(_.objInclude(@obj, keys)).toEqual k1: 1, kN: {kN1: "n1", kN3: "defN3"}

      it 'filters obj correctly when defaults are overrided', ->
        @obj.k2 = "new val"
        keys = k1: null, k2: 2
        expect(_.objInclude(@obj, keys)).toEqual k1: 1, k2: "new val"

  describe '.findAllRegexMatches', ->

    beforeEach ->
      @str = "heyquery what is que in spanish"

    it 'returns correct indices for regex matches when found', ->
      re = /que/gi
      indices = _.findAllRegexMatches re, @str
      expect(indices).toEqual [3, 17]
      re = /\bque/gi
      indices = _.findAllRegexMatches re, @str
      expect(indices).toEqual [17]
      re = new RegExp 'Alg', 'gi'
      indices = _.findAllRegexMatches re, 'Algebra and Linear Exps.'
      expect(indices).toEqual [0]

    it 'returns empty array when no matches', ->
      re = /\bempty/gi
      indices = _.findAllRegexMatches re, @str
      expect(indices).toEqual []
