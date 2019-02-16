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
        if val
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

