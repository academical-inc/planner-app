
H          = require '../../../SpecHelper'
Students   = require '../../../../app/scripts/api/resources/Students'
Academical = require '../../../../app/scripts/api/Academical'


describe 'Students', ->

  beforeEach ->
    @api      = new Academical {}
    @students = new Students @api
    @cb       = H.spy "cb"

    H.ajax.install()

  afterEach ->
    H.ajax.uninstall()

  describe '#retrieve', ->

    it 'sends the correct request', ->
      @students.retrieve "12345", @cb
      H.ajax.assertRequest(
        "get"
        @api.get "host"
        @api.get "protocol"
        "/students/12345"
      )

    it 'sends the correct request when data provided', ->
      @students.retrieve "12345", {count: true}, @cb
      H.ajax.assertRequest(
        "get"
        @api.get "host"
        @api.get "protocol"
        "/students/12345"
        data: {count: true}
      )
