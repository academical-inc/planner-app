
superagent = require 'superagent'


module.exports = (method, url, cb, {data, headers, timeout}={})->
    data    ?= {}
    headers ?= {}
    timeout ?= 0

    req = superagent method, url
      .set headers
      .timeout timeout

    (if method.toLowerCase() == "get"
      req.query data
    else
      req.send data
    ).end cb

