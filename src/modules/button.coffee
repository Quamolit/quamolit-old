
creator = require '../creator'

rect = require '../elements/rect'
text = require '../elements/text'

module.exports = creator.create
  name: 'button'

  propTypes:
    onClick: 'Function'

  getKeyframe: ->
    x: 0
    y: 0
    w: @props.w or 50
    h: @props.h or 20

  getEnteringKeyframe: ->
    x: -40
    y: 0
    w: 0
    h: 0

  getLeavingKeyframe: ->
    @getEnteringKeyframe()

  onClick: (event) ->
    @props.onClick event

  render: ->
    rect
      w: @frame.w
      h: @frame.h
    ,
      onClick: @onClick
      color: 'hsl(30,40%,80%)'
      text {},
        text: @props.text
        color: 'hsl(0,0%,0%)'
