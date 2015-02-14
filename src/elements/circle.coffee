
creator = require '../creator'

arc = require './arc'

module.exports = creator.create
  name: 'circle'

  getKeyframe: ->
    {}

  getEnteringKeyframe: ->
    {}

  getLeavingKeyframe: ->
    @getEnteringKeyframe()

  coveredPoint: (x, y) ->
    centerX = @base.x + (@layout.x or 0)
    centerY = @base.y + (@layout.y or 0)
    distance2 = Math.pow(x - centerX, 2) + Math.pow(y - centerY, 2)
    r2 = Math.pow(@props.radius, 2)
    distance2 < r2

  render: ->
    arc
      radius: @props.radius
      startAngle: 0
      endAngle: 360
      anti: @props.anti
      fillStyle: @props.fillStyle
      strokeStyle: @props.strokeStyle
