
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'text'
  period: 'stable'

  coveredPoint: (x, y) -> false

  render: ->
    (base, manager) =>
      type: 'text'
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
      from: @props.from or {x: 0, y: 0}
      text: @props.text
      family: @props.family or 'Optima'
      size: @props.size or 14
      textAlign: @props.textAlign or 'center'
      textBaseline: @props.textBaseline or 'middle'
      fillStyle: @props.color or 'hsl(240,50%,50%)'
