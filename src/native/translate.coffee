
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'native-translate'
  period: 'stable'

  coveredPoint: (x, y) -> false

  render: ->
    (base, manager) =>
      type: 'translate'
      x: @props.x or 0
      y: @props.y or 0
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
