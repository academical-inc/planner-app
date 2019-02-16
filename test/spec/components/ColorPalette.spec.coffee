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

H            = require '../../SpecHelper'
ColorPalette = require '../../../app/scripts/components/ColorPalette'


describe "ColorPalette", ->

  describe "#render", ->

    beforeEach ->
      @restore = H.rewire ColorPalette, UiConstants: COLORS: ["#fff", "#000"]
      @handler = H.spy "handler"
      @palette = H.render ColorPalette, handleColorSelect: @handler
      @colors = H.scryWithClass @palette, "color"

    afterEach ->
      @restore()

    it 'should render the provided colors correctly', ->
      expect(@colors.length).toEqual 2
      expect(@colors[0].getDOMNode().dataset.color).toEqual "#fff"
      expect(@colors[1].getDOMNode().dataset.color).toEqual "#000"

    it 'should call the callback correctly', ->
      colorNode = @colors[0].getDOMNode()
      H.sim.click colorNode
      expect(@handler).toHaveBeenCalled()

