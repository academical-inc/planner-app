
React       = require 'react'
SectionItem = require './SectionItem.react'
R           = React.DOM

SectionList = React.createClass(

  getInitialState: ->
    data: ["Algebra", "Spanish"]

  render: ->
    accordionId = "pla-section-list-accordion"
    R.div className: "pla-section-list container-fluid",
      R.h4 null, "Classes: 1 Credits: 3"
      R.div {className: "panel-group", id: accordionId, role: "tablist", ariaMultiselectable: "true"},
        (SectionItem({key: sec, parent: accordionId}) for sec in @state.data)
)

module.exports = SectionList


