
$     = require 'jquery'
React = require 'react/addons'
R     = React.DOM


# Private
errorElements = []

module.exports =

  _formFieldsPresent: (cb)->
    if @formFields?
      cb()
    else
      throw new Error "FormMixin: Must set list of formFields to validate"

  clearFormErrors: ->
    for el in errorElements
      el.removeClass 'has-error'

  clearFields: ->
    @_formFieldsPresent =>
      for field in @formFields()
        @refs[field].getDOMNode().value = ''

  validateForm: (cb)->
    @_formFieldsPresent =>
      res   = {}
      valid = true
      for field in @formFields()
        el = $(@refs[field].getDOMNode())
        val = el.val().trim()
        if !!val
          res[field] = val
        else
          el.parent().addClass 'has-error'
          errorElements.push el.parent()
          valid = false
      cb res if valid

