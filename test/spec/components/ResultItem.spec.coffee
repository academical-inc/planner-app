
H          = require '../../SpecHelper'
ResultItem = require '../../../app/scripts/components/ResultItem'


describe 'ResultItem', ->

  beforeEach ->
    @sec  =
      sectionId: "123456"
      courseName: "Algebra and Linear Bra Exps."
      courseCode: "MATE1205"
      teacherNames: ["Alfonso Ruiz", "German Bravo"]
      departments: [{name: "Mathematics"}]
    @query = "Alg"
    @item = H.render ResultItem,
      section: @sec
      query: @query

  describe '#highlight', ->

    it 'highlights query inside result item correctly', ->
      span = @item.highlight @sec.courseName, "Alg"
      expect(span.props.children.length).toEqual 2
      strongs = H.scryWithTag span, "strong"
      expect(strongs.length).toEqual 1
      expect(strongs[0].props.children).toEqual "Alg"

    it 'highlights query inside result item correctly when more than one match', ->
      span = @item.highlight @sec.courseName, "bra"
      expect(span.props.children.length).toEqual 5
      strongs = H.scryWithTag span, "strong"
      expect(strongs.length).toEqual 2
      expect(strongs[0].props.children).toEqual "bra"
      expect(strongs[1].props.children).toEqual "Bra"

    it 'highlights nothing when query does not match', ->
      span = @item.highlight @sec.courseName, "xxxx"
      expect(span.props.children).toEqual @sec.courseName

    it 'highlights nothing when query is empty', ->
      span = @item.highlight @sec.courseName, ""
      expect(span.props.children).toEqual @sec.courseName

  describe '#render', ->


