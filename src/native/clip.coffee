
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'native-clip'
  period: 'stable'

  coveredPoint: (x, y) -> false

  render: ->
    (base, manager) =>
      dx = @props.x - (@props.w / 2)
      dy = @props.y - (@props.h / 2)

      type: 'clip'
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
      x: dx
      y: dy
      w: @props.w
      h: @props.h
