

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
