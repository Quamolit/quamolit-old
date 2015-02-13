
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'arc'
  period: 'stable'

  coveredPoint: (x, y) -> false

  render: ->
    (base, manager) =>
      type: 'arc'
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
      radius: @props.radius
      startAngle: @props.startAngle
      endAngle: @props.endAngle
      anti: @props.anti
      fillStyle: @props.fillStyle
      strokeStyle: @props.strokeStyle
