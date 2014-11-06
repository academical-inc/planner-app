
React       = require 'react'
SectionItem = require './SectionItem.react'
R           = React.DOM

SectionList = React.createClass(

  getInitialState: ->
    data: [
      {
        id: "1"
        name: "MATE1203 - Algebra"
      },
      {
        id: "2"
        name: "LANG1505 - Spanish"
      }
    ]

  render: ->
    R.div className: "pla-section-list container-fluid",
      R.h5 className: "stats", "Classes: 2 Credits: 6"
      R.div(
        {
          className: "panel-group"
          role: "tablist"
          "aria-multiselectable": "true"
        },
        (SectionItem(key: s.id, section: s) for s in @state.data)
      )
)

module.exports = SectionList


