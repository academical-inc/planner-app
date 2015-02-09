
H         = require '../../../SpecHelper'
Schedules = require '../../../../app/scripts/api/resources/Schedules'
Academical = require '../../../../app/scripts/api/Academical'


describe 'Schedules', ->

  beforeEach ->
    @api       = new Academical {}
    @schedules = new Schedules @api
    @cb        = H.spy "cb"
    H.ajax.install()

  afterEach ->
    H.ajax.uninstall()

  describe 'create', ->

    it 'sends the correct request', ->
      data = {name: "S1", studentId: "12345"}
      @schedules.create data, @cb
      H.ajax.assertRequest(
        "post"
        @api.get "host"
        @api.get "protocol"
        "/schedules"
        data: data
      )


  describe 'update', ->

    it 'sends the correct request', ->


  describe 'del', ->

    it 'sends the correct request', ->

