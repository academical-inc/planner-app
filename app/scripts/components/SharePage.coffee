React              = require 'react'
SharePageHeader    = React.createFactory require './SharePageHeader'
SingleSchedulePage = React.createFactory require './SingleSchedulePage'
R                  = React.DOM

SharePage = React.createClass(

  render : ->
    R.div className: 'pla-content container-fluid',
      SharePageHeader({})
      R.section className: 'pla-share-page',
        R.div className: 'row',
          R.div className:  'col-md-offset-1 col-md-10',
            SingleSchedulePage({})
)

module.exports = SharePage
