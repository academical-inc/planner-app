
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


