
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'bezier'
  period: 'stable'

  coveredPoint: (x, y) -> false

  render: ->
    (base, manager) =>
      type: 'bezier'
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
      x: @props.x
      y: @props.y
      between: @props.between
