
H            = require '../../SpecHelper'
PreviewStore = require '../../../app/scripts/stores/PreviewStore'
{ActionTypes} = require '../../../app/scripts/constants/PlannerConstants'


describe 'PreviewStore', ->

  beforeEach ->
    @assertPreview = (prev, res1, res2, overlap)=>
      expect(@prev()).toEqual prev
      expect(@prevEvs()[0].event.isOverlapping).toBe res1
      expect(@prevEvs()[1].event.isOverlapping).toBe res2
      expect(@overlap()).toBe overlap

    @preview = id: "prev1"
    @sectionEvents = [
      {
        section: id: "sec1"
        event:  # Tuesday 10-1120
          startDt: "2015-01-06T10:00:00-05:00"
          endDt:   "2015-01-06T11:20:00-05:00"
      }
      {
        section: id: "sec1"
        event:  # Thursday 10-1120
          startDt: "2015-01-08T10:00:00-05:00"
          endDt:   "2015-01-08T11:20:00-05:00"
      }
    ]
    @previewEvents = [
      {
        section: @preview
        event:  # Tuesday 1130-1250
          startDt: "2015-01-06T11:30:00-05:00"
          endDt:   "2015-01-06T12:50:00-05:00"
      }
      {
        section: @preview
        event:  # Thursday 1130-1250
          startDt: "2015-01-08T11:30:00-05:00"
          endDt:   "2015-01-08T12:50:00-05:00"
      }
    ]

    @payloads =
      add:
        action:
          type: ActionTypes.ADD_SECTION_PREVIEW
          section: @preview
      remove:
        action:
          type: ActionTypes.REMOVE_SECTION_PREVIEW

    @dispatch = PreviewStore.dispatchCallback
    @prev     = PreviewStore.getPreview
    @prevEvs  = PreviewStore.getPreviewEvents
    @overlap  = PreviewStore.isOverlapping

    H.spyOn PreviewStore, "emitChange"
    @restore = H.rewire PreviewStore,
      _preview: null
      _previewEvents: []
      _isOverlapping: false
      "SectionStore.getCurrentSectionEvents": H.spy "s1", retVal: @sectionEvents
      "SectionUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents

  afterEach ->
    @restore() if @restore?


  describe 'init', ->

    it 'initializes store correctly', ->
      expect(PreviewStore.dispatchToken).toBeDefined()


  describe 'when ADD_SECTION_PREVIEW received', ->

    it 'adds correctly when no event overlap', ->
      @dispatch @payloads.add
      expect(@prev()).toEqual @preview
      expect(@prevEvs()).toEqual @previewEvents
      expect(@overlap()).toBe false

    it 'adds correctly when one preview event overlaps entirely', ->
      @previewEvents[0].event.startDt = "2015-01-06T10:00:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T11:20:00-05:00"
      H.rewire PreviewStore,
        "SectionUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.add
      @assertPreview @preview, true, undefined, true

    it 'adds correctly when all preview events overlap', ->
      @previewEvents[0].event.startDt = "2015-01-06T10:00:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T11:20:00-05:00"
      @previewEvents[1].event.startDt = "2015-01-06T10:00:00-05:00"
      @previewEvents[1].event.endDt   = "2015-01-06T11:20:00-05:00"
      H.rewire PreviewStore,
        "SectionUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.add
      @assertPreview @preview, true, true, true

    it 'adds correctly when preview event overlaps with start time', ->
      @previewEvents[0].event.startDt = "2015-01-06T09:00:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T10:20:00-05:00"
      H.rewire PreviewStore,
        "SectionUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.add
      @assertPreview @preview, true, undefined, true

    it 'adds correctly when preview event overlaps with end time', ->
      @previewEvents[0].event.startDt = "2015-01-06T11:00:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T12:20:00-05:00"
      H.rewire PreviewStore,
        "SectionUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.add
      @assertPreview @preview, true, undefined, true

    it 'adds correctly when preview event overlaps inside', ->
      @previewEvents[0].event.startDt = "2015-01-06T10:10:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T11:00:00-05:00"
      H.rewire PreviewStore,
        "SectionUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.add
      @assertPreview @preview, true, undefined, true

    it 'adds correctly when preview event overlaps outside', ->
      @previewEvents[0].event.startDt = "2015-01-06T09:50:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T11:30:00-05:00"
      H.rewire PreviewStore,
        "SectionUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.add
      @assertPreview @preview, true, undefined, true


  describe 'when REMOVE_SECTION_PREVIEW received', ->

    it 'correctly removes preview', ->
      H.rewire PreviewStore,
        _preview: @preview
        _previewEvents: @previewEvents
        _isOverlapping: false

      @dispatch @payloads.remove
      expect(@prev()).toBeNull()
      expect(@prevEvs()).toEqual []
      expect(@overlap()).toBe false
