
H              = require '../../SpecHelper'
PreviewStore   = require '../../../app/scripts/stores/PreviewStore'
{PreviewTypes} = require '../../../app/scripts/constants/PlannerConstants'
{ActionTypes}  = require '../../../app/scripts/constants/PlannerConstants'


describe 'PreviewStore', ->

  beforeEach ->
    @assertPreview = (prev, res1, res2, overlap)=>
      expect(@primary()).toEqual prev
      expect(@primaryEvs()[0].event.isOverlapping).toBe res1
      expect(@primaryEvs()[1].event.isOverlapping).toBe res2
      expect(@overlap()).toBe overlap

    @primaryType   = "primary"
    @secondaryType = "secondary"
    @primaryPrev   = id: "prev1"
    @secondaryPrev = id: "prev2"

    @previews = {}
    @previews[@primaryType] =
      section: null
      events: []
    @previews[@secondaryType] =
      section: null
      events: []

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
        section: @primary
        event:  # Tuesday 1130-1250
          startDt: "2015-01-06T11:30:00-05:00"
          endDt:   "2015-01-06T12:50:00-05:00"
      }
      {
        section: @primary
        event:  # Thursday 1130-1250
          startDt: "2015-01-08T11:30:00-05:00"
          endDt:   "2015-01-08T12:50:00-05:00"
      }
    ]

    @payloads =
      addPrimary:
        action:
          type: ActionTypes.ADD_SECTION_PREVIEW
          previewType: @primaryType
          section: @primaryPrev
      addSecondary:
        action:
          type: ActionTypes.ADD_SECTION_PREVIEW
          previewType: @secondaryType
          section: @secondaryPrev
      removePrimary:
        action:
          type: ActionTypes.REMOVE_SECTION_PREVIEW
          previewType: @primaryType
      removeSecondary:
        action:
          type: ActionTypes.REMOVE_SECTION_PREVIEW
          previewType: @secondaryType

    @dispatch     = PreviewStore.dispatchCallback
    @primary      = PreviewStore.primary
    @primaryEvs   = PreviewStore.primaryEvents
    @secondary    = PreviewStore.secondary
    @secondaryEvs = PreviewStore.secondaryEvents
    @overlap      = PreviewStore.isOverlapping

    H.spyOn PreviewStore, "emitChange"
    @restore = H.rewire PreviewStore,
      _previews: @previews
      _isOverlapping: false
      "SectionStore.sectionEvents": H.spy "s1", retVal: @sectionEvents
      "EventUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      PreviewTypes:
        PRIMARY: @primaryType
        SECONDARY: @secondaryType

  afterEach ->
    @restore() if @restore?


  describe 'init', ->

    it 'initializes store correctly', ->
      expect(PreviewStore.dispatchToken).toBeDefined()


  describe 'when ADD_SECTION_PREVIEW received', ->

    it 'adds primary preview correctly', ->
      @dispatch @payloads.addPrimary
      expect(@primary()).toEqual @primaryPrev
      expect(@primaryEvs()).toEqual @previewEvents
      expect(@overlap()).toBe false

    it 'adds secondary preview correctly', ->
      @dispatch @payloads.addSecondary
      expect(@secondary()).toEqual @secondaryPrev
      expect(@secondaryEvs()).toEqual @previewEvents
      expect(@overlap()).toBe false

    it 'adds primary and secondary previews correctly', ->
      @dispatch @payloads.addPrimary
      @dispatch @payloads.addSecondary
      expect(@primary()).toEqual @primaryPrev
      expect(@primaryEvs()).toEqual @previewEvents
      expect(@overlap()).toBe false
      expect(@secondary()).toEqual @secondaryPrev
      expect(@secondaryEvs()).toEqual @previewEvents
      expect(@overlap()).toBe false

    it 'adds correctly when one preview event overlaps entirely', ->
      @previewEvents[0].event.startDt = "2015-01-06T10:00:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T11:20:00-05:00"
      H.rewire PreviewStore,
        "EventUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.addPrimary
      @assertPreview @primaryPrev, true, undefined, true

    it 'adds correctly when all preview events overlap', ->
      @previewEvents[0].event.startDt = "2015-01-06T10:00:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T11:20:00-05:00"
      @previewEvents[1].event.startDt = "2015-01-06T10:00:00-05:00"
      @previewEvents[1].event.endDt   = "2015-01-06T11:20:00-05:00"
      H.rewire PreviewStore,
        "EventUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.addPrimary
      @assertPreview @primaryPrev, true, true, true

    it 'adds correctly when preview event overlaps with start time', ->
      @previewEvents[0].event.startDt = "2015-01-06T09:00:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T10:20:00-05:00"
      H.rewire PreviewStore,
        "EventUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.addPrimary
      @assertPreview @primaryPrev, true, undefined, true

    it 'adds correctly when preview event overlaps with end time', ->
      @previewEvents[0].event.startDt = "2015-01-06T11:00:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T12:20:00-05:00"
      H.rewire PreviewStore,
        "EventUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.addPrimary
      @assertPreview @primaryPrev, true, undefined, true

    it 'adds correctly when preview event overlaps inside', ->
      @previewEvents[0].event.startDt = "2015-01-06T10:10:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T11:00:00-05:00"
      H.rewire PreviewStore,
        "EventUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.addPrimary
      @assertPreview @primaryPrev, true, undefined, true

    it 'adds correctly when preview event overlaps outside', ->
      @previewEvents[0].event.startDt = "2015-01-06T09:50:00-05:00"
      @previewEvents[0].event.endDt   = "2015-01-06T11:30:00-05:00"
      H.rewire PreviewStore,
        "EventUtils.getSectionEvents": H.spy "s2", retVal: @previewEvents
      @dispatch @payloads.addPrimary
      @assertPreview @primaryPrev, true, undefined, true


  describe 'when REMOVE_SECTION_PREVIEW received', ->

    it 'correctly removes primary preview', ->
      @previews[@primaryType] =
        section: @primaryPrev
        events: @previewEvents
      H.rewire PreviewStore,
        _previews: @previews
        _isOverlapping: false
        PreviewTypes:
          PRIMARY: @primaryType
          SECONDARY: @secondaryType

      @dispatch @payloads.removePrimary
      expect(@primary()).toBeNull()
      expect(@primaryEvs()).toEqual []
      expect(@overlap()).toBe false

    it 'correctly removes secondary preview', ->
      @previews[@primaryType] =
        section: @primaryPrev
        events: @previewEvents
      H.rewire PreviewStore,
        _previews: @previews
        _isOverlapping: false
        PreviewTypes:
          PRIMARY: @primaryType
          SECONDARY: @secondaryType

      @dispatch @payloads.removeSecondary
      expect(@secondary()).toBeNull()
      expect(@secondaryEvs()).toEqual []
      expect(@overlap()).toBe false
