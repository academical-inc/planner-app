
H            = require '../../SpecHelper'
StudentStore = require '../../../app/scripts/stores/StudentStore'


describe 'StudentStore', ->

  describe '.init', ->

    beforeEach ->
      @currentStudent = "123456"
      @success = H.spy "success"
      @attrs =
        id: @currentStudent
        username: "jdoe3"
        email: "jdoe3@test.co"
      H.ajax.install()

    afterEach ->
      H.ajax.uninstall()

    it 'fetches the student correctly', ->
      StudentStore.init @currentStudent, success: @success
      req = H.ajax.mostRecent()

      H.ajax.succeed @attrs

      expect(StudentStore._student.attributes).toEqual @attrs
      expect(@success).toHaveBeenCalledWith StudentStore._student

