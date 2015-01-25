
creator = require '../creator'

rect = require './rect'

module.exports = creator.create
  name: 'check'

  propTypes:
    checked: 'Boolean'
    onClick: 'Function'

  getKeyframe: ->
    x: 0
    y: 0
    outerSize: 20
    innerSize: if @props.checked then 10 else 0

  getEnteringKeyframe: ->
    x: -40
    y: 0
    outerSize: 0
    innerSize: 0

  getLeavingKeyframe: ->
    x: -40
    y: 0
    outerSize: 0
    innerSize: 0

  onClick: (event) ->
    @props.onClick event

  render: ->
    rect
      vector:
        x: @frame.outerSize
        y: @frame.outerSize
    ,
      onClick: @onClick
      color: 'hsla(240,30%,80%,0.5)'
      rect
        vector:
          x: @frame.innerSize
          y: @frame.innerSize
      ,
        color: 'hsl(240,80%,40%)'
