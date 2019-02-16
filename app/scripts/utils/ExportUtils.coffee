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

Html2Canvas = require 'html2canvas'
DOMUtils    = require './DOMUtils'


# TODO Test
class ExportUtils

  @exportToImage: (element, onRendered)->
    Html2Canvas element, onrendered: onRendered

  @download: (name, data)->
    link = DOMUtils.createElement 'a'
    link.href = data
    link.target = "_blank"
    link.download = name
    DOMUtils.fireEvent link, 'click'

  @downloadImage: (name, canvas)->
    @download "#{name}.png", canvas.toDataURL("image/png")

  @downloadICS: (name, icsData)->
    icsData = encodeURIComponent icsData
    @download "#{name}.ics", "data:text/calendar;charset=utf-8,#{icsData}"



module.exports = ExportUtils
