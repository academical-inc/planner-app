
React = require 'react/addons'
R     = React.DOM


Dropdown = React.createClass(

  getInitialState: ->
    title: @props.title

  handleItemSelected: (item)->
    if @props.updateNameOnSelect == true
      @setState title: item.val
    @props.handleItemSelected item if @props.handleItemSelected?

  renderItems: (items)->
    r = []
    items.forEach (item, index)=>
      if item.header?
        r.push R.li(className: "dropdown-header", key: item.header, item.header)
        r = r.concat (
          for it in item.items
            R.li key: it.key, onClick: @handleItemSelected.bind(this, it),
              if it.icon?
                R.a href: "#", it.icon, " #{it.val}"
              else
                R.a href: "#", it.val
        )
        if index != items.length-1
          r.push R.li(className: "divider", key: "#{item.header}-divider")
      else
        r.push (
          R.li key: item.key, onClick: @handleItemSelected.bind(this, item),
            if item.icon?
              R.a href: "#", item.icon, " #{item.val}"
            else
              R.a href: "#", item.val
        )
    return r

  render: ->
    classes = dropdown: true
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
      )
)

module.exports = Dropdown

