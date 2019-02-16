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

H               = require '../../SpecHelper'
SlideMenuHandle = require '../../../app/scripts/components/SlideMenuHandle'


describe "SlideMenuHandle", ->

  describe 'css classes', ->

    it 'is hidden on medium and large screens', ->
      slideMenu = H.render SlideMenuHandle, scheduleListSelector: "selector"
      expect(slideMenu.getDOMNode().className).toContain 'hidden-md'
      expect(slideMenu.getDOMNode().className).toContain 'hidden-lg'


  describe 'on click', ->

    it 'should open slide menu', ->
      [mock$, mock$El] = H.mock$()
      restore = H.rewire SlideMenuHandle,
        $: mock$
        UiConstants:
          selectors: SCHEDULE_LIST: "selector"

      slideMenu = H.render SlideMenuHandle

      H.sim.click(slideMenu.getDOMNode())
      expect(mock$).toHaveBeenCalledWith "selector"
      expect(mock$El.data).toHaveBeenCalledWith "mmenu"
      restore()

