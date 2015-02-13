
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'native-restore'
  period: 'stable'

  coveredPoint: (x, y) -> false

  render: ->
    (base, manager) =>
      type: 'restore'
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
