
$             = require 'jquery'
React         = require 'react'
ClickOutside  = require 'react-onclickoutside'
Classnames    = require 'classnames'
I18nMixin     = require '../mixins/I18nMixin'
FormMixin     = require '../mixins/FormMixin'
R             = React.DOM


Dropdown = React.createClass(

  mixins: [I18nMixin, ClickOutside, FormMixin]

  getDefaultProps: ->
    closeOnAdd: true

  toggleDropdown: (e)->
    e.preventDefault() if e?
    $(@getDOMNode()).toggleClass "open"

  closeDropdown: ->
    $(@getDOMNode()).removeClass "open"

  getInitialState: ->
    buttonDisabled: true
    inputDisabled: @props.items.length >= @props.maxItems

  formFields: ->
    ["itemName"]

  componentWillReceiveProps: (nextProps)->
    if nextProps.items.length >= @props.maxItems
      @setState buttonDisabled: true, inputDisabled: true
    else
      @setState inputDisabled: false

  handleItemAdd: (e)->
    e.preventDefault()
    @clearFormErrors()
    @validateForm (fields)=>
      @props.handleItemAdd fields.itemName
      @clearFields()
      @handleInputChange()
      @closeDropdown() if @props.closeOnAdd

  handleItemSelected: (e, item)->
    e.preventDefault()
    @props.handleItemSelected item if @props.handleItemSelected?
    @closeDropdown()

  handleInputChange: (e)->
    val = @refs.itemName.getDOMNode().value.trim()
    if val.length is 0
      @setState buttonDisabled: true
    else if @props.maxInputLength? and val.length > @props.maxInputLength
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
        R.div className: 'form-group',
          R.input
            className: "form-control"
            ref: "itemName"
            type: "text"
            placeholder: @props.addItemPlaceholder
            disabled: @state.inputDisabled
            maxLength: @props.maxInputLength
            onChange: @handleInputChange
        R.button
          className: 'btn btn-success btn-xs'
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
      else if item.divider is true
        r.push R.li(className: "divider", key: "divider-#{index}")
      else
        r.push @getItem(item)
    r

  render: ->
    classes = {}
    classes["pla-dropdown"]   = true
    classes["dropdown"]       = true
    classes[@props.className] = @props.className?

    classes = Classnames classes

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

