
React = require 'react/addons'
R     = React.DOM


Dropdown = React.createClass(

  getInitialState: ->
    title: @props.title

  handleItemSelected: (item)->
    if @props.updateNameOnSelect == true
      @setState title: item.val
    @props.handleItemSelected item if @props.handleItemSelected?

  getItem: (item)->
    @props.itemType
      key: item.id
      item: item
      onClick: @handleItemSelected.bind this, item
      handleItemDelete: @props.handleItemDelete

  renderAddInput: ->
    R.li key: "add-input",
      R.form className: 'navbar-form',
        R.div className: 'form-group',
          R.input type: "text", placeholder: @props.addItemPlaceholder
        R.button
          className: 'btn btn-info btn-xs'
          type: "submit"
          onClick: @props.handleItemAdd
          "Add"

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

    ulProps = className: "dropdown-menu", role: "menu"
    ul = if @props.handleItemAdd?
      R.ul ulProps,
        @renderItems(@props.items).concat [
          R.li className: "divider", key: "add-divider"
          @renderAddInput()
        ]
    else
      R.ul ulProps, @renderItems(@props.items)

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
      ul
)

module.exports = Dropdown

