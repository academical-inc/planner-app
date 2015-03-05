
$     = require 'jquery'
React = require 'react/addons'
R     = React.DOM


# Private
_errorElements     = []

module.exports =

  _formFieldsPresent: (cb)->
    if @formFields?
      cb()
    else
      throw new Error "FormMixin: Must set list of formFields to validate"

  clearFormErrors: ->
    for el in _errorElements
      el.removeClass 'has-error'
    _errorElements = []

  clearFields: ->
    @_formFieldsPresent =>
      for field in @formFields()
        @refs[field].getDOMNode().value = ''

  addError: (el)->
    el.addClass 'has-error'
    _errorElements.push el

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
          @addError el.parent()
          valid = false
      if @customValidations?
        for validation in @customValidations()
          el = validation()
          if el?
            @addError $(el)
            valid = false
      cb res if valid

