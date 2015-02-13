
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'native-alpha'
  period: 'stable'

  coveredPoint: (x, y) -> false

  render: ->
    (base, manager) =>
      type: 'alpha'
      value: @props.value
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
