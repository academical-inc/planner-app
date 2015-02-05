
H          = require '../../../SpecHelper'
Schools    = require '../../../../app/scripts/api/resources/Schools'
Academical = require '../../../../app/scripts/api/Academical'

describe 'Schools', ->

  beforeEach ->
    @api     = new Academical {}
    @schools = new Schools @api
    @cb      = H.spy "cb"

    H.ajax.install()

  afterEach ->
    H.ajax.uninstall()

  describe '#retrieve', ->

    it 'sends the correct request', ->
      @schools.retrieve "12345", @cb
      H.ajax.assertRequest(
        "get"
        @api.get "host"
        @api.get "protocol"
        "/schools/12345"
      )

    it 'sends the correct request when data provided', ->
      @schools.retrieve "12345", {count: true}, @cb
      H.ajax.assertRequest(
        "get"
        @api.get "host"
        @api.get "protocol"
        "/schools/12345"
        data: {count: true}
      )
