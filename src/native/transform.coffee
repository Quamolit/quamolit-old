
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'native-transform'
  period: 'stable'

  coveredPoint: (x, y) -> false

  render: ->
    (base, manager) =>
      type: 'transform'
      x: @props.x # array
      y: @props.y # array
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
