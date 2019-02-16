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


# TODO Test
class DOMUtils

  @createElement: (tag)->
    document.createElement tag

  @fireEvent: (element, eventName)->
    doc = element.ownerDocument

    if element.dispatchEvent?
      eventClass = switch eventName
        when 'click'
          'MouseEvents'
        else
          throw new Error "DOMUtils.fireEvent: Couldn't find an event
            class for event #{eventName}"

      ev = doc.createEvent eventClass
      ev.initEvent eventName, true, true
      ev.synthetic = true
      element.dispatchEvent ev, true
    else if element.fireEvent
      ev = doc.createEventObject()
      ev.synthetic = true
      element.fireEvent "on#{eventName}", ev



module.exports = DOMUtils
