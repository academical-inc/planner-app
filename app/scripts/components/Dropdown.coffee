
React = require 'react'
$     = require 'jquery'
mq    = require '../utils/MediaQueries.coffee'
R     = React.DOM

Dropdown = React.createClass(

  componentDidMount: ->
    if not mq.matchesMDAndUp()
      $(@getDOMNode()).mmenu(
        dragOpen:
          open: true
      )
    return

  getInitialState: ->
    data: ["Schedule1", "Schedule2"]

  render: ->
    R.div className: 'dropdown',
      R.button(
        {
          className: 'btn btn-default dropdown-toggle'
          type: 'button'
          id: 'dropdownMenu1'
          'data-toggle': 'dropdown'
          'aria-expanded': 'true'
        }
        "Opciones "
        R.span className: 'caret', null
      )
      R.ul(
        {
          className:'dropdown-menu'
          role: 'menu'
          'aria-labelledby': 'dropdownMenu1'
        }
        R.li({role:'presentation'}
          R.a({role:'menuitem',tabindex:'-1',href:'#'},"General:")
        )
        R.li({role:'presentation'}
          R.a({role:'menuitem',tabindex:'-1',href:'#'},"Resumen")
        )
        R.li({role:'presentation'}
          R.a({role:'menuitem',tabindex:'-1',href:'#'},"Cambiar Nombre")
        )
        R.li({role:'presentation'}
          R.a({role:'menuitem',tabindex:'-1',href:'#'},"Duplicar")
        )
        R.li({role:'presentation'}
          R.a({role:'menuitem',tabindex:'-1',href:'#'},"Comparte tu Horario")
        )
        R.li({role:'presentation'}
          R.a({role:'menuitem',tabindex:'-1',href:'#'},"Borrar")
        )
        R.li({role:'presentation'}
          R.a({role:'menuitem',tabindex:'-1',href:'#'},"Exportar:")
        )
        R.li({role:'presentation'}
          R.a({role:'menuitem',tabindex:'-1',href:'#'},"Calendario")
        )
        R.li({role:'presentation'}
          R.a({role:'menuitem',tabindex:'-1',href:'#'},"Imagen")
        )
      )
      # R.ul null
      # R.button({className:'btn btn-default dropdown-toggle',
        # type:'button',id:'dropdownMenu1','data-toggle':'dropdown',
        # 'aria-expanded':'true'},null)
      # R.ul null, (R.li(key: sch, sch) for sch in @state.data)
)

module.exports = Dropdown

