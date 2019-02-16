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

H    = require '../../SpecHelper'
I18n = require '../../../app/scripts/utils/I18n'


describe 'I18n', ->

  afterEach ->
    I18n.init()

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


  describe '._templateAll', ->

    it 'replaces correct values in the array of strings', ->
      t = ["Some", "t {{x}}", "{{x}} - {{y}}"]
      res = I18n._templateAll t, x: 5, y: 7
      expect(res).toEqual ["Some", "t 5", "5 - 7"]


  describe '.init', ->

    beforeEach ->
      H.spyOn I18n, "setLocale"
      @restore = H.rewire I18n, DEFAULT_LOCALE: "fr"

    afterEach ->
      @restore()

    it 'should set locale to module default if no argument passed', ->
      I18n.init()
      expect(I18n.setLocale).toHaveBeenCalledWith "fr"

    it 'should set locale to default passed as parameter', ->
      I18n.init("en")
      expect(I18n.setLocale).toHaveBeenCalledWith "en"


  describe '.setLocale', ->

    beforeEach ->
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


  describe '.t', ->

    beforeEach ->
      I18n.localeMessages = {s1: {m1: "{{val}}", m2: "m2"},\
        s2: {m1: "m1"}, m1: "m1", a1: ["a1", "{{valA1}}"]}

    it 'returns correct translation for given key', ->
      expect(I18n.t("m1")).toEqual "m1"
      expect(I18n.t("s2.m1")).toEqual "m1"
      expect(I18n.t("s1.m2")).toEqual "m2"

    it 'returns translation with correct values when values are given', ->
      expect(I18n.t("s1.m1", val: 5)).toEqual "5"

    it 'returns translation with correct values when array present', ->
      expect(I18n.t("a1", valA1: 5)).toEqual ["a1", "5"]

    it 'throws error when key not present', ->
      expect(-> I18n.t("m2")).toThrowError()

