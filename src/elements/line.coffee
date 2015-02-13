
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'line'
  period: 'stable'

  coveredPoint: (x, y) -> false

  render: ->
    (base, manager) =>
      type: 'line'
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
      x: @props.x
      y: @props.y
