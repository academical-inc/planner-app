
H    = require '../../SpecHelper'
I18n = require '../../../app/scripts/utils/I18n'


describe 'I18n', ->


  describe '._simpleLocale', ->

    it 'returns the simplified version of locale', ->
      expect(I18n._simpleLocale("en-US")).toEqual "en"
      expect(I18n._simpleLocale("es-AR")).toEqual "es"
      expect(I18n._simpleLocale("es")).toEqual "es"
      expect(I18n._simpleLocale("en")).toEqual "en"


  describe '._valueFor', ->

    beforeEach ->
      @o = {a: "a", b: {c: "c"}, d: {e: {f: "f"}}}

    it 'returns the correct value in the object given a nested key', ->
      expect(I18n._valueFor("b.c", @o)).toEqual "c"
      expect(I18n._valueFor("d.e.f", @o)).toEqual "f"

    it 'returns the correct value in the object given a simple key', ->
      expect(I18n._valueFor("a", @o)).toEqual "a"

    it 'throws error if key is not present', ->
      expect(-> I18n._valueFor("x")).toThrowError()
      expect(-> I18n._valueFor("b.x")).toThrowError()
      expect(-> I18n._valueFor("d.e.x")).toThrowError()


  describe '._template', ->

    beforeEach ->
      @t = "Hello {{first}} {{last}}"

    it 'should replace the correct values in the text', ->
      vals = first: "John", last: "Doe"
      expect(I18n._template(@t, vals)).toEqual "Hello John Doe"

    it 'does not replace text when values not present', ->
      expect(I18n._template(@t, {})).toEqual @t
      expect(I18n._template(@t, last: "Doe")).toEqual "Hello {{first}} Doe"

    it 'replaces all ocurrences of a value', ->
      @t = "Hey {{first}}, {{first}}"
      expect(I18n._template(@t, first: "John")).toEqual "Hey John, John"


  describe '.init', ->

    beforeEach ->
      @restore = H.rewire I18n, DEFAULT_LOCALE: "fr"

    afterEach ->
      @restore()

    it 'should set locale to module default if no argument passed', ->
      I18n.init()
      expect(I18n.locale).toEqual "fr"

    it 'should set locale to default passed as parameter', ->
      I18n.init("en")
      expect(I18n.locale).toEqual "en"


  describe '.setLocale', ->

    beforeEach ->
      I18n.init()
      @restore = H.rewire I18n, messages: en: "data", es: "other"

    afterEach ->
      @restore()

    it 'sets locale correctly if messages exists for this locale', ->
      I18n.setLocale("es")
      expect(I18n.locale).toEqual "es"
      expect(I18n.localeMessages).toEqual "other"

    it 'sets default locale if no messages for given locale', ->
      I18n.setLocale("de")
      expect(I18n.locale).toEqual "en"
      expect(I18n.localeMessages).toEqual "data"

    it 'throws error if no messages present at all', ->
      @restore = H.rewire I18n, messages: {}
      expect(-> I18n.setLocale("de")).toThrowError()

    it 'thows error if module has not been inited', ->
      I18n.locale = undefined
      expect(-> I18n.setLocale("es")).toThrowError()


  describe '.t', ->

    beforeEach ->
      I18n.localeMessages = {s1: {m1: "{{val}}", m2: "m2"},\
        s2: {m1: "m1"}, m1: "m1"}

    it 'returns correct translation for given key', ->
      expect(I18n.t("m1")).toEqual "m1"
      expect(I18n.t("s2.m1")).toEqual "m1"
      expect(I18n.t("s1.m2")).toEqual "m2"

    it 'resturns translation with correct values when values are given', ->
      expect(I18n.t("s1.m1", val: 5)).toEqual "5"

    it 'throws error when key not present', ->
      expect(-> I18n.t("m2")).toThrowError()

