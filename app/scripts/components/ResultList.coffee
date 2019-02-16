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

React      = require 'react'
I18nMixin  = require '../mixins/I18nMixin'
ResultItem = React.createFactory require './ResultItem'
R          = React.DOM


# TODO Test
ResultList = React.createClass(

  mixins: [I18nMixin]

  handleResultMouseEnter: (idx)->
    @props.handleResultMouseEnter idx

  handleResultMouseLeave: (idx)->
    @props.handleResultMouseLeave idx

  handleResultClicked: (e)->
    e.preventDefault()
    @props.handleResultClicked()

  renderNullItem: (idx)->
    R.li
      key: "no-result-#{idx}"
      className: 'no-result'
      R.span null, @t("searchBar.noResults")

  renderItem: (result, idx, focused, disabled)->
    className = "result"
    className += " result-focused" if focused
    className += " result-disabled" if disabled
    R.li
      key: "result-#{idx}"
      className: className,
      onMouseEnter: @handleResultMouseEnter.bind @, idx
      onMouseLeave: @handleResultMouseLeave.bind @, idx
      onMouseDown: @handleResultClicked
      ResultItem
        section: result
        query: @props.query
        focused: focused

  render: ->
    R.ul className: 'pla-result-list',
      @props.results.map (result, i)=>
        if result?
          @renderItem(
            result
            i
            i is @props.focusedIndex
            i is @props.disabledIndex
          )
        else
          @renderNullItem i

)

module.exports = ResultList
