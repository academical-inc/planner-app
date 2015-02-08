
H       = require '../../SpecHelper'
request = require '../../../app/scripts/api/request'


describe 'request', ->

  beforeEach ->
    H.ajax.install()
    @cb = H.spy "callback"
    @data = {d1: "d1", d2: "d2"}

  afterEach ->
    H.ajax.uninstall()

  it 'sends correct query string when GETing', ->
    req = request "get", "https://host.com", @cb, data: @data
    expect(req._query[0]).toEqual "d1=d1&d2=d2"
    expect(req._data).toBeUndefined()

  it 'sends correct data in body otherwise', ->
    req = request "post", "https://host.com", @cb, data: @data
    expect(req._query.length).toEqual 0
    expect(req._data).toEqual @data

  it 'calls the callback on success', ->
    req = request "post", "https://host.com", @cb
    H.ajax.succeed success: true
    expect(@cb).toHaveBeenCalled()

  it 'calls the callback on failure', ->
    req = request "post", "https://host.com", @cb
    H.ajax.fail()
    expect(@cb).toHaveBeenCalled()

