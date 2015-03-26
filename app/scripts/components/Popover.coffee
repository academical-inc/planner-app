
React = require 'react'
R     = React.DOM


Popover = React.createClass(

  componentDidMount: ->
    $el = $(@getDOMNode())
    $el.popover
      react: true
      title: @props.title
      content: @props.content
      trigger: @props.trigger or ''
      placement: @props.placement if @props.placement?
    if @props.visible
      $el.popover 'show'

  componentDidUpdate: (prevProps, prevState) ->
    $el = $(@getDOMNode())
    if prevProps.visible != @props.visible
      $el.popover if @props.visible then 'show' else 'hide'

  componentWillUnmount: ->
    # Clean up before destroying: this isn't strictly
    # necessary, but it prevents memory leaks
    $el = $(@getDOMNode())
    popover = $el.data('bs.popover')
    $tip = popover.tip()
    React.unmountComponentAtNode $tip.find('.popover-title')[0]
    React.unmountComponentAtNode $tip.find('.popover-content')[0]
    $(@getDOMNode()).popover 'destroy'

  render: ->
    @props.children

)

module.exports = Popover
