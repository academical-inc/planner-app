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

messages = require '../../locales/i18n.json'

DEFAULT_LOCALE = "en"

class I18n

  @_simpleLocale: (locale)->
    locale[0..1]

  @_valueFor: (key, messages)->
    return messages[key] if key of messages
    keys  = key.split "."
    first = keys[0]
    throw new Error("Unknown key #{key}") if not (first of messages)
    @_valueFor keys.slice(1).join("."), messages[first]

  @_template: (text, values)->
    for key of values
      text = text.replace new RegExp("{{#{key}}}", "g"), values[key]
    text

  @_templateAll: (lines, values)->
    lines.map (line)=>
      @_template line, values

  @init: (locale)->
    @setLocale (locale || DEFAULT_LOCALE)

  @setLocale = (locale)->
    locale = @_simpleLocale locale

    if locale of messages
      @locale = locale
      @localeMessages = messages[locale]
    else if DEFAULT_LOCALE of messages
      @locale = DEFAULT_LOCALE
      console.warn "Message translations missing for the provided
        locale '#{locale}'. Falling back to default locale: '#{@locale}'"
      @localeMessages = messages[@locale]
    else
      throw new Error("Message translations missing for locale #{locale}")

  @t = (key, values)->
    res = @_valueFor key, @localeMessages
    if values?
      res = if Array.isArray res
        @_templateAll res, values
      else
        @_template res, values
    res


module.exports = I18n
