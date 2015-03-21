$     = require 'jquery'
React = require 'react'

# Patch Bootstrap popover to take a React component instead of a
# plain HTML string
$.extend $.fn.popover.Constructor.DEFAULTS, react: false
oldSetContent = $.fn.popover.Constructor::setContent

$.fn.popover.Constructor::setContent = ->
  if not @options.react
    return oldSetContent.call(this)
  $tip = @tip()
  title = @getTitle()
  content = @getContent()
  $tip.removeClass 'fade top bottom left right in'
  # If we've already rendered, there's no need to render again
  if not $tip.find('.popover-content').html()
    # Render title, if any
    $title = $tip.find('.popover-title')
    if title
      React.renderComponent title, $title[0]
    else
      $title.hide()
    React.renderComponent content, $tip.find('.popover-content')[0]
  return

