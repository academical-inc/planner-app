
helper          = require '../../SpecHelper'
SlideMenuHandle = require '../../../app/scripts/components/SlideMenuHandle'

describe "SlideMenuHandle", ->

  describe 'css classes', ->

    it 'is hidden on medium and large screens', ->
      slideMenu = helper.TestUtils.renderIntoDocument SlideMenuHandle(
        scheduleListSelector: "selector"
        $: {}
      )
      expect(slideMenu.getDOMNode().className).toContain 'hidden-md'
      expect(slideMenu.getDOMNode().className).toContain 'hidden-lg'


  describe 'on click', ->

    it 'should open slide menu', ->
      [mock$, mock$El] = helper.mock$()

      slideMenu = helper.TestUtils.renderIntoDocument SlideMenuHandle(
        scheduleListSelector: "selector"
        $: mock$
      )

      helper.TestUtils.Simulate.click(slideMenu.getDOMNode())
      expect(mock$).toHaveBeenCalledWith "selector"
      expect(mock$El.trigger).toHaveBeenCalledWith "open.mm"


