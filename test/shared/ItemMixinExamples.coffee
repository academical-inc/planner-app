
$     = require 'jquery'
H     = require '../SpecHelper'
React = require 'react'

ItemMixinExamples =

  item: ({itemClass}={})->
    beforeEach ->
      @handler = @handler or H.spy "deleteHandler"

    describe '#renderDeleteIcon', ->

      it 'renders correctly if item is being deleted', ->
        @data.del = true
        item = H.render itemClass,
          item: @data
        deleteIcon = item.renderDeleteIcon()
        expect(deleteIcon.props.className).toContain "spinner"

      it 'renders correctly if item is not being deleted', ->
        item = H.render itemClass,
          item: @data
        deleteIcon = item.renderDeleteIcon()
        expect(deleteIcon.props.className).toContain "delete-icon"

      it 'calls the on delete item callback correctly', ->
        item = H.render itemClass,
          item: @data
          handleItemDelete: @handler
        div = H.render 'div', null, item.renderDeleteIcon()

        deleteIcon = H.findWithClass div, 'delete-icon'
        H.sim.click deleteIcon.getDOMNode()
        expect(@handler).toHaveBeenCalledWith @data

    describe '#renderSettings', ->

      it 'renders settings trigger correctly', ->
        item = H.render itemClass, item: @data
        settingsTrigger = item.renderSettings()
        itemSettings = settingsTrigger.props.content
        deleteIcon = itemSettings.props.deleteIcon
        expect(itemSettings.props.handleColorSelect).toEqual \
          item.handleColorSelect
        expect(deleteIcon.props.onClick).toEqual item.handleItemDelete


jasmine.sharedExamples = if jasmine.sharedExamples?
  $.extend {}, true, jasmine.sharedExamples, ItemMixinExamples
else
  ItemMixinExamples

