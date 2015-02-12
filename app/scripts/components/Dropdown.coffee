
React         = require 'react/addons'
I18nMixin     = require '../mixins/I18nMixin'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM

MAX_INPUT_LENGTH = UiConstants.dropdown.MAX_INPUT_LENGTH


Dropdown = React.createClass(

  mixins: [I18nMixin]

  getInitialState: ->
    buttonDisabled: false

  handleItemAdd: (e)->
    e.preventDefault()
    itemName = @refs.itemName.getDOMNode().value.trim()
    @props.handleItemAdd itemName
    @refs.itemName.getDOMNode().value = ''

  handleItemSelected: (item)->
    @props.handleItemSelected item if @props.handleItemSelected?

  handleInputChange: (e)->
    val = @refs.itemName.getDOMNode().value.trim()
    if val.length >= MAX_INPUT_LENGTH
      @setState buttonDisabled: true
    else
      @setState buttonDisabled: false

  getItem: (item)->
    @props.itemType
      key: item.id
      item: item
      onClick: @handleItemSelected.bind this, item
      handleItemDelete: @props.handleItemDelete

  renderAddInput: ->
    R.li key: "add-input",
      R.form className: 'navbar-form', onSubmit: @handleItemAdd,
        R.div className: 'form-group',
          R.input
            ref: "itemName"
            type: "text"
            placeholder: @props.addItemPlaceholder
            onChange: @handleInputChange
        R.button
          className: 'btn btn-info btn-xs'
          type: "submit"
          disabled: @state.buttonDisabled
          @t "dropdown.addBtn"

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

    @props.rootTag className: classes, id: @props.id,
      R.a(
        {
          className: "dropdown-toggle"
          role: "button"
          href: "#"
          "data-toggle": "dropdown"
          "aria-expanded": false
        }
        @props.title
        R.span className: 'caret'
      )
      ul
)

module.exports = Dropdown

