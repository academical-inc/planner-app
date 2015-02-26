
$             = require 'jquery'
React         = require 'react/addons'
ClickOutside  = require 'react-onclickoutside'
I18nMixin     = require '../mixins/I18nMixin'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM

MAX_INPUT_LENGTH = UiConstants.dropdown.MAX_INPUT_LENGTH


Dropdown = React.createClass(

  mixins: [I18nMixin, ClickOutside]

  toggleDropdown: (e)->
    e.preventDefault() if e?
    $(@getDOMNode()).toggleClass "open"

  closeDropdown: ->
    $(@getDOMNode()).removeClass "open"

  getInitialState: ->
    buttonDisabled: false

  handleItemAdd: (e)->
    e.preventDefault()
    $(@refs.inputFormGroup.getDOMNode()).removeClass 'has-error'
    itemName = @refs.itemName.getDOMNode().value.trim()
    if !!itemName
      @props.handleItemAdd itemName
      @refs.itemName.getDOMNode().value = ''
      @closeDropdown()
    else
      $(@refs.inputFormGroup.getDOMNode()).addClass 'has-error'

  handleItemSelected: (e, item)->
    e.preventDefault()
    @props.handleItemSelected item if @props.handleItemSelected?
    @closeDropdown()

  handleInputChange: (e)->
    val = @refs.itemName.getDOMNode().value.trim()
    if val.length >= MAX_INPUT_LENGTH
      @setState buttonDisabled: true
    else
      @setState buttonDisabled: false

  handleClickOutside: (e)->
    @closeDropdown()

  getItem: (item)->
    @props.itemType
      key: item.id
      item: item
      onClick: (e)=>
        @handleItemSelected e, item
      handleItemDelete: @props.handleItemDelete

  renderAddInput: ->
    R.li key: "add-input",
      R.form className: 'navbar-form', onSubmit: @handleItemAdd,
        R.div className: 'form-group', ref: "inputFormGroup",
          R.input
            className: "form-control"
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
          onClick: @toggleDropdown
          "aria-expanded": false
        }
        @props.title
        R.span className: 'caret'
      )
      ul
)

module.exports = Dropdown

