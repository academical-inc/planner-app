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


StoreMixin = (stores...)->
  last = stores[stores.length-1]
  handlerName = if last.handler?
    last.handler
  else
    "onChange"

  _store = (storeInfo)->
    if storeInfo.store?
      [storeInfo.store, storeInfo.handler or handlerName]
    else
      [storeInfo, handlerName]

  {
    componentDidMount: ->
      for storeInfo in stores
        [store, handler] = _store storeInfo
        if not @[handler]?
          throw new Error "Handler #{handler} not defined on the component"
        store.addChangeListener @[handler]

    componentWillUnmount: ->
      for storeInfo in stores
        [store, handler] = _store storeInfo
        store.removeChangeListener @[handler]
  }




module.exports = StoreMixin
