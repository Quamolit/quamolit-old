
creator = require '../creator'

rect = require './rect'
text = require './text'

module.exports = creator.create
  name: 'button'

  propTypes:
    onClick: 'Function'

  getKeyframe: ->
    x: 0
    y: 0
    vx: @props.vx or 50
    vy: @props.vy or 20

  getEnteringKeyframe: ->
    x: -40
    y: 0
    vx: 0
    vy: 0

  getLeavingKeyframe: ->
    x: -40
    y: 0
    vx: 0
    vy: 0

  onClick: (event) ->
    @props.onClick event

  render: ->
    rect
      vector:
        x: @frame.vx
        y: @frame.vy
    ,
      onClick: @onClick
      color: 'hsl(30,40%,80%)'
      text {},
        text: @props.text
        color: 'hsl(0,0%,0%)'
