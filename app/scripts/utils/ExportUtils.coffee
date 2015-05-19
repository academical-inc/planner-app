
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
