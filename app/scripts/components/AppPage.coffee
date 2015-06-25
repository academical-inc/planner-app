
React           = require 'react'
_               = require '../utils/Utils'
StoreMixin      = require '../mixins/StoreMixin'
UserStore       = require '../stores/UserStore'
AppActions      = require '../actions/AppActions'
LoadingView     = React.createFactory require './LoadingView'
AppBody         = React.createFactory require './AppBody'
SlideMenuHandle = React.createFactory require './SlideMenuHandle'
AppModals       = React.createFactory require './AppModals'
AppHeader       = React.createFactory require './AppHeader'
R               = React.DOM

{POLL_INTERVAL} = require '../constants/PlannerConstants'


# Private
# TODO Test
# OK because POLL_INTERVAL will always be sufficiently big
_interval = null
_initSchedules = _.debounce(
  (userId, initialScheduleId)->
    AppActions.getSchedules userId, initialScheduleId
    _interval = setInterval(
      AppActions.updateSchedules.bind(AppActions,userId), POLL_INTERVAL
    )
    return
  , 0
)


# TODO Test
AppPage = React.createClass(

  mixins: [StoreMixin(UserStore)]

  getState: ->
    userId: UserStore.user().id

  getInitialState: ->
    @getState()

  onChange: ->
    if UserStore.user()?
      @setState @getState()
    else
      clearInterval _interval

  componentDidMount: ->
    if @state.userId?
      _initSchedules @state.userId, @props.initialScheduleId
    else
      AppActions.fetchUser UserStore.user()

  componentWillUpdate: (nextProps, nextState)->
    if not @state.userId? and nextState.userId?
      _initSchedules nextState.userId, @props.initialScheduleId

  render: ->
    if @state.userId?
      R.div className: 'pla-content container-fluid',
        SlideMenuHandle({})
        AppHeader({})
        AppBody ui: @props.ui
        AppModals ui: @props.ui
    else
      R.div className: 'pla-content container-fluid',
        LoadingView {}
        AppModals ui: @props.ui

)

module.exports = AppPage
