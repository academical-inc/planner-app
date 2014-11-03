
React       = require 'react'
SectionItem = require './SectionItem.react'
R           = React.DOM

SectionList = React.createClass(

  getInitialState: ->
    data: ["Algebra", "Spanish"]

  render: ->
    accId = "pla-section-list-accordion"
    R.div className: "pla-section-list container-fluid",
      R.h5 null, "Classes: 2 Credits: 6"
      R.div(
        {
          className: "panel-group"
          id: accId
          role: "tablist"
          "aria-multiselectable": "true"
        },
        (SectionItem(key: sec, accSelector: "##{accId}") for sec in @state.data)
      )
)

module.exports = SectionList


