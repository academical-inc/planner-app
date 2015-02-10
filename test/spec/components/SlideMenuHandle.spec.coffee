
H               = require '../../SpecHelper'
SlideMenuHandle = require '../../../app/scripts/components/SlideMenuHandle'


describe "SlideMenuHandle", ->

  describe 'css classes', ->

    it 'is hidden on medium and large screens', ->
      slideMenu = H.render SlideMenuHandle, scheduleListSelector: "selector"
      expect(slideMenu.getDOMNode().className).toContain 'hidden-md'
      expect(slideMenu.getDOMNode().className).toContain 'hidden-lg'


  describe 'on click', ->

    it 'should open slide menu', ->
      [mock$, mock$El] = H.mock$()
      restore = H.rewire SlideMenuHandle,
        $: mock$
        UiConstants:
          selectors: SCHEDULE_LIST: "selector"

      slideMenu = H.render SlideMenuHandle

      H.sim.click(slideMenu.getDOMNode())
      expect(mock$).toHaveBeenCalledWith "selector"
      expect(mock$El.trigger).toHaveBeenCalledWith "open.mm"
      restore()

