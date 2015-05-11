
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


  describe '.filter', ->

    beforeEach ->
      @arr = [34, 2, 2, {data: 5}, {data: 6}, {data: 5}]

    it 'finds all elements that match test function', ->
      res = _.filter @arr, (datum)-> datum is 2
      expect(res).toEqual [2, 2]
      res = _.filter @arr, (datum)-> datum.data is 5
      expect(res).toEqual [{data: 5}, {data: 5}]

    it 'returns empty array if no values found', ->
      res = _.filter @arr, (datum)-> datum is "poof"
      expect(res).toEqual []

    it 'returns empty array if array is empty', ->
      res = _.filter [], (datum)-> datum is 5
      expect(res).toEqual []


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


  describe '.objFilter', ->

    beforeEach ->
      @obj = k1: 1, k3: 3

    it 'filters keys in obj when keys to filter is array', ->
      keys = ["k1", "k2"]
      expect(_.objFilter(@obj, keys)).toEqual k1: 1

    it 'filters obj correctly when keys to filter is object', ->
      keys = k1: null, k2: null
      expect(_.objFilter(@obj, keys)).toEqual k1: 1

    it 'filters correctly when test function provided', ->
      keys = ["k1", "k3"]
      test = (val)-> val == 1
      expect(_.objFilter(@obj, keys, test)).toEqual k1: 1

    describe 'when defaults present', ->

      it 'filters object correctly when defaults are values', ->
        keys = k1: null, k2: 2
        expect(_.objFilter(@obj, keys)).toEqual k1: 1, k2: 2

      it 'filters object correctly when defaults are functions', ->
        keys = k1: null, k2: -> 2
        expect(_.objFilter(@obj, keys)).toEqual k1: 1, k2: 2

      it 'filters object correctly when defaults are overrided', ->
        @obj.k2 = "new val"
        keys = k1: null, k2: 2
        expect(_.objFilter(@obj, keys)).toEqual k1: 1, k2: "new val"

      it 'filters object correctly when test func also provided', ->
        @obj.k4 = 4
        keys = k1: null, k2: 2, k4: null
        test = (val)-> val == 1
        expect(_.objFilter(@obj, keys, test)).toEqual k1: 1, k2: 2

      it 'filters object correctly when test func also provided and def overrided', ->
        @obj.k2 = 1
        keys = k1: null, k2: 2
        test = (val)-> val == 1
        expect(_.objFilter(@obj, keys, test)).toEqual k1: 1, k2: 1


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
