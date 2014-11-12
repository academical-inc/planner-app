
React     = require 'react/addons'
TestUtils = React.addons.TestUtils

class SpecHelper

  @React: React
  @TestUtils: TestUtils

  @mock$: ({spyFuncs}={})->
    spyFuncs ?= ["trigger", "mmenu", "fullCalendar", "timepicker"]
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

  @findAllInTree: (tree, test)->
    return findAllInRenderedTree tree, test if not TestUtils.isElement tree
    return [] if not tree?

    ret = if test tree then [tree] else []

    if tree.props? and tree.props.children?\
        and Array.isArray tree.props.children
      children = tree.props.children
      for child in children
        ret = ret.concat(
          SpecHelper.findAllInTree child, test
        )
    ret

  @findWithTag: (tree, tagName)->
    if TestUtils.isElement tree
      res = SpecHelper.findAllInTree tree, (el)->
        el.type == tagName
      if res.length != 1
        throw new Error "Did not find exactly one match for tag: #{tagName}"
      res[0]
    else
      TestUtils.findRenderedDOMComponentWithTag tree, tagName

  @scryWithTag: (tree, tagName)->
    if TestUtils.isElement tree
      SpecHelper.findAllInTree tree, (el)->
        el.type == tagName
    else
      TestUtils.scryRenderedDOMComponentsWithTag tree, tagName

  @sim: TestUtils.Simulate



module.exports = SpecHelper
