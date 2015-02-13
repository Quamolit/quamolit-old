
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'native-save'
  period: 'stable'

  coveredPoint: (x, y) -> false

  render: ->
    (base, manager) =>
      type: 'save'
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
