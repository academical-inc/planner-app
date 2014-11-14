
H     = require '../../SpecHelper'
Modal = require '../../../app/scripts/components/Modal'


describe "Modal", ->

  beforeEach ->
    @cancelHandler = H.spy "cancelHandler"
    @acceptHandler = H.spy "acceptHandler"
    @defaultData =
        cancel:
          type: "danger"
          text: "Cancel"
        accept:
          type: "success"
          text: "Save"

    @customData =
        cancel:
          type:    "cancel-type"
          text:    "Off"
          handler: @cancelHandler
        accept:
          type:    "accept-type"
          text:    "On"
          handler: @acceptHandler

  assertRenderedButtons = (buttons, data)->
    cancelBtn = buttons[0]
    acceptBtn = buttons[1]

    expect(buttons.length).toEqual 2
    expect(cancelBtn.props["data-dismiss"]).toEqual "modal"
    expect(cancelBtn.props.className).toEqual "btn btn-#{data.cancel.type}"
    expect(cancelBtn.props.children).toEqual data.cancel.text
    expect(acceptBtn.props.className).toEqual "btn btn-#{data.accept.type}"
    expect(acceptBtn.props.children).toEqual data.accept.text

    if data.cancel.handler?
      expect(cancelBtn.props.onClick).toEqual data.cancel.handler
    if data.accept.handler?
      expect(acceptBtn.props.onClick).toEqual data.accept.handler


  describe "#renderButtons", ->

    beforeEach ->
      @modal = H.render Modal

    it 'renders defaults correctly if no buttons provided', ->
      buttons = @modal.renderButtons()
      assertRenderedButtons buttons, @defaultData

    it 'renders provided buttons correctly', ->
      buttons = @modal.renderButtons @customData
      assertRenderedButtons buttons, @customData


  describe "#render", ->

    it 'renders button descriptors passed in the properties', ->
      modal   = H.render Modal, buttons: @customData
      footer  = H.findWithClass modal, "modal-footer"
      buttons = footer.props.children

      assertRenderedButtons buttons, @customData

    it 'renders with correct id, header and children', ->
      modal  = H.render Modal, id: "modal-id", header: "My Header", "Body"
      header = H.findWithTag modal, "h4"
      body   = H.findWithClass modal, "modal-body"

      expect(modal.props.id).toEqual "modal-id"
      expect(header.props.id).toEqual "modal-id-label"
      expect(header.props.children).toEqual "My Header"
      expect(body.props.children).toEqual "Body"

    it 'triggers handlers correctly', ->
      modal = H.render Modal, buttons: @customData
      cancelBtn = H.findWithClass modal, "btn-#{@customData.cancel.type}"
      acceptBtn = H.findWithClass modal, "btn-#{@customData.accept.type}"

      H.sim.click cancelBtn.getDOMNode()
      expect(@cancelHandler).toHaveBeenCalled()

      H.sim.click acceptBtn.getDOMNode()
      expect(@acceptHandler).toHaveBeenCalled()



