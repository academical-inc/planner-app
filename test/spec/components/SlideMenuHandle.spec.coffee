
helper          = require '../../SpecHelper'
SlideMenuHandle = require '../../../app/scripts/components/SlideMenuHandle.react'

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
      mockEl = jasmine.createSpyObj "mockEl", ["trigger"]
      mock$ = jasmine.createSpy("mock$").and.returnValue mockEl

      slideMenu = helper.TestUtils.renderIntoDocument SlideMenuHandle(
        scheduleListSelector: "selector"
        $: mock$
      )

      helper.TestUtils.Simulate.click(slideMenu.getDOMNode())
      expect(mock$).toHaveBeenCalledWith "selector"
      expect(mockEl.trigger).toHaveBeenCalledWith "open.mm"


