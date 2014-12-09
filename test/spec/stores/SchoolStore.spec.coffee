
H           = require '../../SpecHelper'
SchoolStore = require '../../../app/scripts/stores/SchoolStore'


describe 'SchoolStore', ->

  describe '.init', ->

    beforeEach ->
      @currentSchool = "uniandes"
      @attrs        = {name: "U1", nickname: @currentSchool}
      @success      = H.spy "success"
      @complete     = H.spy "complete"
      @restore = H.rewire SchoolStore,
        ApiUtils: H.mockCurrentSchool(@currentSchool)

    afterEach ->
      @restore()

    describe 'when school is cached', ->

      beforeEach ->
        @restoreInner = H.rewire SchoolStore,
          LsCache: H.mockLsCache(@attrs)

      afterEach ->
        @restoreInner()

      it 'creates school from cache correctly', ->
        SchoolStore.init success: @success, complete: @complete
        expect(@success).toHaveBeenCalledWith SchoolStore._school
        expect(@complete).toHaveBeenCalled()
        expect(SchoolStore._school.attributes).toEqual @attrs


    describe 'when school is not cached', ->

      beforeEach ->
        H.ajax.install()
        @lscache = H.mockLsCache()
        @restoreInner = H.rewire SchoolStore,
          LsCache: @lscache
          EXPIRE_MINS: 5

      afterEach ->
        @restoreInner()
        H.ajax.uninstall()

      it 'fetches the school correctly', ->
        SchoolStore.init success: @success
        req = H.ajax.mostRecent()
        expect(req.url).toEqual "schools/uniandes"

        H.ajax.succeed @attrs

        expect(@lscache.set).toHaveBeenCalledWith(
          @currentSchool
          @attrs
          5
        )
        expect(@success).toHaveBeenCalledWith SchoolStore._school

