
$             = require 'jquery'
React         = require 'react'
_             = require '../utils/Utils'
GoogleApi     = require '../utils/GoogleApi'
ModalMixin    = require '../mixins/ModalMixin'
I18nMixin     = require '../mixins/I18nMixin'
IconMixin     = require '../mixins/IconMixin'
StoreMixin    = require '../mixins/StoreMixin'
ScheduleStore = require '../stores/ScheduleStore'
R             = React.DOM

{
  UiConstants: {
    ids: {SHARE_MODAL},
    share: {MAC_COPY, PC_COPY}
  },
  ShareConstants: {FB_SHARE_URL, TW_SHARE_URL}
} = require '../constants/PlannerConstants'
{FB_APP_ID} = require '../Env'


# TODO move into a store
# Private State
_urls = {}

# TODO Test
ShareDialog = React.createClass(

  mixins: [I18nMixin, ModalMixin, IconMixin, StoreMixin(ScheduleStore)]

  getInitialState: ->
    link: ""

  copyMsg: ->
    if _.isMac() then MAC_COPY else PC_COPY

  longUrl: (id)->
    "#{window.location.origin}/schedules/#{id}"

  fbUrl: (id)->
    toShare = @longUrl id
    params = $.param(
      app_id: FB_APP_ID
      display: "popup"
      href: toShare
      redirect_uri: toShare
    )
    "#{FB_SHARE_URL}?#{params}"

  twUrl: (id)->
    toShare = _urls[id] or @longUrl(id)
    params = $.param(
      text: @t('shareDialog.msg') + toShare
    )
    "#{TW_SHARE_URL}?#{params}"

  fbShare: ->
    url = @fbUrl ScheduleStore.current().id
    _.openWindow url

  twShare: ->
    url = @twUrl ScheduleStore.current().id
    _.openWindow url

  onChange: ->
    cur = ScheduleStore.current()
    if cur?
      if not _urls[cur.id]?
        GoogleApi.shorten @longUrl(cur.id),
          (err, shortUrl)=>
            if err?
              @setState link: @longUrl(cur.id)
            else
              _urls[cur.id] = shortUrl
              @setState link: shortUrl
      else
        @setState link: _urls[cur.id]
    else
      @setState link: ""

  onShown: ->
    @refs.copyInput.getDOMNode().select()

  renderBody: ->
    R.form className: 'pla-share-dialog',
      R.div className: "form-group",
        R.label htmlFor: "copy-input", @t("shareDialog.linkMsg")
        R.div className: "input-group",
          R.input
            className: "form-control"
            id: "copy-input"
            ref: "copyInput"
            type: "text"
            value: @state.link
            autoComplete: "off"
            readOnly: true
          R.button
            className: "btn btn-success"
            @copyMsg()
      R.div className: "form-group",
        R.label null, @t("shareDialog.socialMsg")
        R.div null,
          @imgIcon "/images/fb_icon.png", onClick: @fbShare
          @imgIcon "/images/tw_icon.png", onClick: @twShare

  render: ->
    @renderModal(
      SHARE_MODAL
      @t "shareDialog.header"
      @renderBody()
      accept: show: false
      cancel: show: false
    )

)

module.exports = ShareDialog
