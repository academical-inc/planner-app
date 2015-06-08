
H          = require '../../SpecHelper'
ErrorStore = require '../../../app/scripts/stores/ErrorStore'
{ActionTypes} = require '../../../app/scripts/constants/PlannerConstants'


describe 'ErrorStore', ->

  beforeEach ->
    @payloads = {}  # Add the action types
    @dispatch = ErrorStore.dispatchCallback
    H.spyOn ErrorStore, "emitChange"
    H.rewire ErrorStore, {}  # Rewire any private state

  afterEach ->
    @restore() if @restore?

  describe 'when error action received', ->


