
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'native-scale'
  period: 'stable'

  coveredPoint: (x, y) -> false

  render: ->
    (base, manager) =>
      type: 'scale'
      x: @props.x or 1
      y: @props.y or 1
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
