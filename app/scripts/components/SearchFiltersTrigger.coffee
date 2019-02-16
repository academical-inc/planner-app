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

React     = require 'react'
I18nMixin = require '../mixins/I18nMixin'
R         = React.DOM


SearchFiltersTrigger = React.createClass(

  mixins: [I18nMixin]

  render: ->
    className = 'pla-search-filters-trigger'
    className += " collapsed" if @props.collapsed
    className += " filtering" if @props.filtering

    title = if @props.filtering
      @t "searchBar.filtering"
    else
      @t "searchBar.filters"

    R.div className: className,
      R.a
        className: "filters-toggle collapsed"
        href: @props.filtersSelector
        "data-toggle": "collapse"
        "aria-expanded": "false"
        "aria-controls": @props.filtersId
        title

)

module.exports = SearchFiltersTrigger
