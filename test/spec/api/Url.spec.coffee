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

H   = require '../../SpecHelper'
Url = require '../../../app/scripts/api/Url'


describe 'Url', ->

  describe '.extractUrlArgsAndData', ->

    it 'extracts all urlArgs when only urlArgs provided', ->
      args = ["arg1", "arg2"]
      [urlArgs, data] = Url.extractUrlArgsAndData args

      expect(urlArgs).toEqual args
      expect(data).toBeUndefined()

    it 'extracts data when only data provided', ->
      argData = {q:1, g:2}
      args    = [argData]
      [urlArgs, data] = Url.extractUrlArgsAndData args

      expect(urlArgs).toEqual []
      expect(data).toEqual argData

    it 'extracts urlArgs and data when both provided', ->
      argData = {q:1, g:2}
      args    = ["arg1", "arg2", argData]
      [urlArgs, data] = Url.extractUrlArgsAndData args

      expect(urlArgs).toEqual ["arg1", "arg2"]
      expect(data).toEqual argData

    it 'extracts nothing when args are empty', ->
      [urlArgs, data] = Url.extractUrlArgsAndData()
      expect(urlArgs).toEqual []
      expect(data).toBeUndefined()

      [urlArgs, data] = Url.extractUrlArgsAndData []
      expect(urlArgs).toEqual []
      expect(data).toBeUndefined()


  describe '.fullUrl', ->

    beforeEach ->
      H.spyOn(Url, "makeUrlInterpolator").and.callFake (path)-> ->path
      @protocol = "https"

    it 'returns correct url when protocol is empty', ->
      p1 = "p1.com"
      url = Url.fullUrl '', p1, {}
      expect(url).toEqual "//p1.com"

    it 'returns correct url when protocol is present', ->
      p1 = "p1.com"
      url = Url.fullUrl @protocol, p1, {}
      expect(url).toEqual "https://p1.com"

    it 'returns fullUrl correctly when all paths are strings', ->
      [p1, p2, p3, p4] = ["p1.com", "/", "p2", "p3"]
      url = Url.fullUrl @protocol, p1, p2, p3, p4, {}

      expect(url).toEqual "https://p1.com/p2/p3"
      expect(Url.makeUrlInterpolator.calls.count()).toEqual 4

    it 'returns fullUrl correctly when functions provided too', ->
      p1 = "p1.com"
      p2 = ()-> "/v1/"
      p3 = "schools"
      url = Url.fullUrl @protocol, p1, p2, p3, {}

      expect(url).toEqual "https://p1.com/v1/schools"
      expect(Url.makeUrlInterpolator.calls.count()).toEqual 2

    it 'throws error when args are not strings', ->
      p1 = "p1.com"
      p2 = ()-> "/v1/"
      p3 = 5
      expect(->Url.fullUrl @protocol, p1, p2, p3, {}).toThrowError()

    it 'throws error when args are not functions that return strings', ->
      p1 = "p1.com"
      p2 = ()-> 5
      p3 = "5"
      expect(->Url.fullUrl @protocol, p1, p2, p3, {}).toThrowError()


  describe '.getUrlParamsObj', ->

    it 'returns correct object of url params when args are correct', ->
      required = ["v1", "v2", "v3"]
      values   = ["1", "2", "3"]

      obj = Url.getUrlParamsObj required, values
      expect(obj).toEqual v1: "1", v2: "2", v3: "3"

    it 'returns an empty object when provided empty args', ->
      obj = Url.getUrlParamsObj [], []
      expect(obj).toEqual {}

    it 'throws error when one of the values is null or undefined', ->
      required = ["v1", "v2", "v3"]
      values   = ["1", null, "3"]
      expect(->Url.getUrlParamsObj(required, values)).toThrowError()

      required = ["v1", "v2", "v3"]
      values   = ["1", undefined, "3"]
      expect(->Url.getUrlParamsObj(required, values)).toThrowError()

    it 'throws error when values are missing for requiredKeys', ->
      required = ["id"]
      values   = []
      expect(->Url.getUrlParamsObj(required, values)).toThrowError()

    it 'throws error when there are more values than requiredKeys', ->
      required = ["id"]
      values   = ["544bc", "445cb"]
      expect(->Url.getUrlParamsObj(required, values)).toThrowError()

