
Html2Canvas = require 'html2canvas'
DOMUtils    = require './DOMUtils'


# TODO Test
class ExportUtils

  @exportToImage: (element, onRendered)->
    Html2Canvas element, onrendered: onRendered

  @downloadImage: (name, canvas)->
    link = DOMUtils.createElement 'a'
    link.href = canvas.toDataURL "image/png"
    link.target = "_blank"
    link.download = "#{name}.png"
    DOMUtils.fireEvent link, 'click'


module.exports = ExportUtils
