#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

$             = require 'jquery'
_             = require 'underscore'
React         = require 'react/addons'
NodeUrl       = require 'url'
Humps         = require 'humps'
Env           = require '../app/scripts/Env'
SchoolStore   = require '../app/scripts/stores/SchoolStore'
{ActionTypes} = require '../app/scripts/constants/PlannerConstants'
I18n          = require '../app/scripts/utils/I18n'
TestUtils     = React.addons.TestUtils

# Init School
SchoolStore.dispatchCallback
  action:
    type: ActionTypes.INIT_SCHOOL
    school: Env.SCHOOL
I18n.init()


class Ajax

  @install: ->
    jasmine.Ajax.install()

  @uninstall: ->
    jasmine.Ajax.uninstall()

  @mostRecent: ->
    jasmine.Ajax.requests.mostRecent()

  @succeed: (data, code=200, req=@mostRecent())->
    req.respondWith
      status: code
      contentType: "application/json"
      responseText: JSON.stringify data: data

  @fail: (code=404, msg="Error", req=@mostRecent())->
    req.respondWith
      status: code
      contentType: "application/json"
      responseText: JSON.stringify message: msg

  @assertRequest: (method, host, protocol, path, {req, data, headers}={})->
    req   ?= @mostRecent()
    method = method.toLowerCase()

    expect(req.method.toLowerCase()).toEqual method

    if headers?
      reqHds = if req.requestHeaders? then req.requestHeaders else req.header
      expect(reqHds).toEqual headers

    url = req.url
    if protocol.length == 0
      protocol = "http"
      url = url[2..] if url.indexOf "//" == 0
      url = "#{protocol}://#{url}"
    url = NodeUrl.parse url
    expect(url.host).toEqual       host
    expect(url.protocol).toEqual   protocol + ":"
    expect(url.pathname).toEqual   path

    if method == "get"
      if data?
        data = Humps.decamelizeKeys data
        expect(url.query).toEqual $.param(data)
      else
        expect(url.query).toBeNull()
    else
      reqData = if req._data? then req._data else req.data()
      if data?
        data = Humps.decamelizeKeys data
        expect(reqData).toEqual data: data
      else
        expect(reqData).toEqual {}


# Private
_divContainer = document.createElement 'div'

afterEach ->
  SpecHelper.unmount()

class SpecHelper

  @React:     React
  @TestUtils: TestUtils
  @ajax:      Ajax
  @$:         $

  @mock$: ({spyFuncs}={})->
    spyFuncs ?= ["mmenu", "fullCalendar", "timepicker", "modal", "datepicker"]
    mock$El = @spyObj "mock$El", spyFuncs
    mock$El.data = @spy "data", retVal: @spyObj("open", ["open"])
    mock$ = @spy "mock$", retVal: mock$El
    [mock$, mock$El]

  @mockComponent: ->
    React.createFactory 'div'

  @mockLsCache: (getRetVal=null)->
    @spyObj "mockLsCache", {get: getRetVal, set: null}

  @mockCurrentSchool: (currentSchool)->
    @spyObj "mockCurrentSchool", {currentSchool: currentSchool}

  @any: jasmine.any

  @spyOn: (obj, key, {retVal}={})->
    if $.isFunction retVal
      spyOn(obj, key).and.callFake retVal
    else
      spyOn(obj, key).and.returnValue retVal

  @spy: (name, {retVal}={})->
    if $.isFunction retVal
      jasmine.createSpy(name).and.callFake retVal
    else
      jasmine.createSpy(name).and.returnValue retVal

  @spyObj: (name, spyFuncs)->
    if Array.isArray spyFuncs
      jasmine.createSpyObj name, spyFuncs
    else if typeof spyFuncs == 'object'
      spy = jasmine.createSpyObj name, Object.keys(spyFuncs)
      for key of spyFuncs
        if $.isFunction spyFuncs[key]
          spy[key].and.callFake spyFuncs[key]
        else
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

  @render: (reactComponent, props={}, children)->
    factory = React.createFactory(reactComponent)
    React.render factory(props, children), _divContainer

  @unmount: ->
    React.unmountComponentAtNode _divContainer

  @rewireAndRender: (reactComponent, props={}, stubs={})->
    restore = @rewire(reactComponent, stubs)
    rendered = @render(reactComponent, props)
    [rendered, restore]

  @findAllInTree: (tree, test)->
    if not tree?
      []
    else if TestUtils.isDOMComponent(tree) or\
        TestUtils.isCompositeComponent(tree)

      TestUtils.findAllInRenderedTree tree, test

    else if TestUtils.isElement(tree)
      ret = if test tree then [tree] else []

      if tree.props? and tree.props.children?
        if Array.isArray tree.props.children
          children = tree.props.children
          for child in children
            ret = ret.concat(
              SpecHelper.findAllInTree child, test
            )
        else
          ret = ret.concat(
            SpecHelper.findAllInTree tree.props.children, test
          )
      ret
    else
      []

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

  @findWithClass: (tree, className)->
    if TestUtils.isElement tree
      res = SpecHelper.findAllInTree tree, (el)->
        el.props.className == className
      if res.length != 1
        throw new Error "Did not find exactly one match for class: #{className}"
      res[0]
    else
      TestUtils.findRenderedDOMComponentWithClass tree, className

  @scryWithClass: (tree, className)->
    if TestUtils.isElement tree
      SpecHelper.findAllInTree tree, (el)->
        el.props.className == className
    else
      TestUtils.scryRenderedDOMComponentsWithClass tree, className

  @findWithId: (tree, id)->
    res = SpecHelper.findAllInTree tree, (el)->
      TestUtils.isDOMComponent(el) and el.props.id == id
    if res.length != 1
      throw new Error "Did not find exactly one match for id: #{id}"
    res[0]

  @scryWithId: (tree, id)->
    SpecHelper.findAllInTree tree, (el)->
      TestUtils.isDOMComponent(el) and el.props.id == id

  @findWithType: TestUtils.findRenderedComponentWithType

  @scryWithType: TestUtils.scryRenderedComponentsWithType

  @sim: TestUtils.Simulate

  # Courtesy of https://robots.thoughtbot.com/jasmine-and-shared-examples
  @itBehavesLike = ->
    exampleName = _.first arguments
    exampleArguments = _.select(_.rest(arguments), (arg) ->
      not _.isFunction(arg)
    )
    innerBlock = _.detect(arguments, (arg) ->
      _.isFunction arg
    )
    exampleGroup = jasmine.sharedExamples[exampleName]
    if exampleGroup
      if _.isFunction exampleGroup
        describe exampleName, ->
          exampleGroup.apply this, exampleArguments
          if innerBlock
            innerBlock()
          return
      else if _.isObject exampleGroup
        _.each exampleGroup, (example, name)->
          describe name, ->
            example.apply this, exampleArguments
            if innerBlock
              innerBlock()
            return
    else
      it "cannot find shared behavior: '#{exampleName}'", ->
        expect(false).toEqual true
        return

module.exports = SpecHelper
