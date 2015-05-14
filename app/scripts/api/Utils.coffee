
# TODO Test
module.exports =

  # https://github.com/epeli/underscore.string
  underscored: (str)->
    str.trim().replace(/([a-z\d])([A-Z]+)/g, '$1_$2').\
      replace(/[-\s]+/g, '_').toLowerCase()

  underscoredKeys: (obj)->
    if Array.isArray obj
      obj.map (el)=> @underscoredKeys el
    else if typeof obj == 'object'
      undObj = {}
      for key of obj
        undObj[@underscored(key)] = @underscoredKeys obj[key]
      undObj
    else
      obj

