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

React        = require 'react'
ClickOutside = require 'react-onclickoutside'
R            = React.DOM


Popover = React.createClass(

  mixins: [ClickOutside]

  componentDidMount: ->
    $el = $(@getDOMNode())
    $el.popover
      react: true
      title: @props.title
      content: @props.content
      trigger: @props.trigger or ''
      placement: @props.placement if @props.placement?
    if @props.visible
      $el.popover 'show'

  componentDidUpdate: (prevProps, prevState) ->
    $el = $(@getDOMNode())
    if prevProps.visible != @props.visible
      $el.popover if @props.visible then 'show' else 'hide'

  componentWillUnmount: ->
    # Clean up before destroying: this isn't strictly
    # necessary, but it prevents memory leaks
    $el = $(@getDOMNode())
    popover = $el.data('bs.popover')
    $tip = popover.tip()
    React.unmountComponentAtNode $tip.find('.popover-title')[0]
    React.unmountComponentAtNode $tip.find('.popover-content')[0]
    $(@getDOMNode()).popover 'destroy'

  handleClickOutside: (e)->
    $el = $(@getDOMNode())
    $el.popover 'hide'

  render: ->
    @props.children

)

module.exports = Popover
