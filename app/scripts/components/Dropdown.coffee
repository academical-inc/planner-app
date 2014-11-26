
React = require 'react/addons'
R     = React.DOM


Dropdown = React.createClass(

  getInitialState: ->
    title: @props.title

  handleItemSelected: (item)->
    if @props.updateNameOnSelect == true
      @setState title: item.val
    @props.handleItemSelected item if @props.handleItemSelected?

  renderAddInput: ->
    R.li null,
      R.form className: 'navbar-form',
        R.div className: 'form-group',
          R.input type: "text", placeholder: "Add item"
        R.button className: 'btn btn-info btn-xs', type: "submit", "Add"

  getItem: (item)->
    @props.itemType
      key: item.id
      item: item
      onClick: @handleItemSelected.bind this, item
      handleItemDelete: @props.handleItemDelete

  renderItems: (items)->
    r = []
    items.forEach (item, index)=>
      if item.header?
        r.push R.li(className: "dropdown-header", key: item.header, item.header)
        r = r.concat (
          for it in item.items
            @getItem it
        )
        if index != items.length-1
          r.push R.li(className: "divider", key: "#{item.header}-divider")
      else
        r.push (
          @getItem item
        )
    return r

  render: ->
    classes = {}
    classes["pla-dropdown"]   = true
    classes["dropdown"]       = true
    classes[@props.className] = @props.className?

    classes = React.addons.classSet classes

    @props.rootTag className: classes,
      R.a(
        {
          className: "dropdown-toggle"
          role: "button"
          href: "#"
          "data-toggle": "dropdown"
          "aria-expanded": false
        }
        @state.title
        R.span className: 'caret'
      )
      R.ul(
        {
          className:"dropdown-menu"
          role: "menu"
        }
        @renderItems @props.items
        R.li className: "divider" if @props.handleItemAdd?
        @renderAddInput() if @props.handleItemAdd?
      )
)

module.exports = Dropdown

