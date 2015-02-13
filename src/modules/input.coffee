
creator = require '../creator'

rect = require '../elements/rect'
text = require '../elements/text'

module.exports = creator.create
  name: 'input'

  propTypes:
    onChange: 'Function'

  getKeyframe: ->
    x: 0
    y: 0
    w: @props.w or 40
    h: @props.h or 20
    text: @props.text or ''

  getEnteringKeyframe: ->
    x: -40
    y: 0
    w: 0
    h: 0
    text: ''

  getLeavingKeyframe: ->
    @getEnteringKeyframe()

  onClick: (event) ->
    @manager.createExternalElement @id, 'input', @props.text

  onChange: (event) ->
    @props.onChange event

  render: ->
    rect
      w: @frame.w
      h: @frame.h
    ,
      onClick: @onClick
      color: 'hsl(120,70%,80%)'
      text {},
        text: (@props.text or '')
        color: 'hsl(0,0%,50%)'
