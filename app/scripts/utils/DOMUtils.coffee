

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
