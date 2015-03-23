
H         = require '../../SpecHelper'
Popover   = require '../../../app/scripts/components/Popover'
EventItem = require '../../../app/scripts/components/EventItem'


describe 'EventItem', ->

  beforeEach ->
    @data =
      id: '1'
      name: "event"
      color: "red"
    @handler = H.spy "handler"

  describe '#render', ->

    it 'renders correctly', ->
      event   = H.render EventItem, item: @data
      heading = H.findWithClass event, "panel-heading"
      name    = H.scryWithTag(event, "a")[0]
      settingsTrigger = H.findWithType event, Popover

      colorsId = "event-colors-#{@data.id}"

      expect(heading.props.id).toEqual "event-heading-#{@data.id}"
      expect(name.props.children).toEqual @data.name
      expect(settingsTrigger).toBeDefined()


  H.itBehavesLike "item", itemClass: EventItem

