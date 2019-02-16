#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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
      React.render title, $title[0]
    else
      $title.hide()
    React.render content, $tip.find('.popover-content')[0]
  return

