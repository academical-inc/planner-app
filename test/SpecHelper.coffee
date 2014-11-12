
React     = require 'react/addons'
TestUtils = React.addons.TestUtils

class SpecHelper

  @React: React
  @TestUtils: TestUtils

  @mock$: ({spyFuncs}={})->
    spyFuncs ?= ["trigger", "mmenu", "fullCalendar"]
    mock$El = @spyObj "mock$El", spyFuncs
    mock$ = @spy "mock$", retVal: mock$El
    [mock$, mock$El]

  @spy: (name, {retVal})->
    jasmine.createSpy(name).and.returnValue retVal

  @spyObj: (name, spyFuncs)->
    if Array.isArray spyFuncs
      jasmine.createSpyObj name, spyFuncs
    else if typeof spyFuncs == 'object'
      spy = jasmine.createSpyObj name, Object.keys(spyFuncs)
      for key of spyFuncs
        spy[key].and.returnValue spyFuncs[key]
      spy
    else
      console.error "'spyFuncs' must be an array or an object"

  @rewire: (mod, stubs={})->
    originals = {}
    for key of stubs
      originals[key] = mod.__get__ key
      mod.__set__ key, stubs[key]

    restore = ->
      for key of originals
        mod.__set__ key, originals[key]
    restore

  @render: (reactComponent, props={})->
    TestUtils.renderIntoDocument React.createFactory(reactComponent)(props)

  @rewireAndRender: (reactComponent, props={}, stubs={})->
    restore = @rewire(reactComponent, stubs)
    rendered = @render(reactComponent, props)
    [rendered, restore]

  @findAllInTree: (reactEl, test)->
    return [] if not reactEl?

    ret = if test reactEl then [reactEl] else []

    if reactEl.props? and reactEl.props.children?\
        and Array.isArray reactEl.props.children
      children = reactEl.props.children
      for child in children
        ret = ret.concat(
          SpecHelper.findAllInTree child, test
        )
    ret

  @sim: TestUtils.Simulate

  @findWithTag: TestUtils.findRenderedDOMComponentWithTag

  @scryWithTag: TestUtils.scryRenderedDOMComponentsWithTag



module.exports = SpecHelper
