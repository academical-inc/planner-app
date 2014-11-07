
React             = require 'react'
SearchBar         = require './SearchBar.react'
PanelItemList     = require './PanelItemList.react'
SectionItem       = require './SectionItem.react'
R                 = React.DOM

PlannerSideBar = React.createClass(

  render: ->
    R.div className: 'pla-side-bar hidden-sm hidden-xs',
      SearchBar({})
      PanelItemList
        itemType: SectionItem
        header: "Classes: 2 Credits: 6"
        initialState: [
          {
            id: "1"
            name: "MATE1203 - Algebra"
          },
          {
            id: "2"
            name: "LANG1505 - Spanish"
          }
        ]

)

module.exports = PlannerSideBar

