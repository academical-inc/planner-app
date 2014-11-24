
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

  @init: (defaultLocale)->
    @locale = DEFAULT_LOCALE
    @locale = defaultLocale if defaultLocale?

  @setLocale = (locale)->
    throw new Error("Must init I18n before setting locale") if not @locale?
    locale = @_simpleLocale locale

    if locale of messages
      @locale = locale
      @localeMessages = messages[locale]
    else if @locale of messages
      console.warn "Message translations missing for the provided
        locale '#{locale}'. Falling back to default locale: '#{@locale}'"
      @localeMessages = messages[@locale]
    else
      throw new Error("Message translations missing for locale #{@locale}")

  @t = (key, values)->
    res = @_valueFor key, @localeMessages
    res = @_template res, values if values?
    res


module.exports = I18n