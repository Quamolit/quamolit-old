
creator = require '../creator'

module.exports = creator.create
  category: 'shape'
  name: 'image'
  period: 'stable'

  coveredPoint: (x, y) ->
    centerX = @base.x + (@layout.x or 0)
    centerY = @base.y + (@layout.y or 0)
    if (Math.abs(x - centerX) * 2) > @props.w then return no
    if (Math.abs(y - centerY) * 2) > @props.h then return no
    return yes

  render: ->
    (base, manager) =>
      type: 'image'
      base:
        x: base.x + (@layout.x or 0)
        y: base.y + (@layout.y or 0)
      src: @props.src
      x: @props.x
      y: @props.y
      w: @props.w
      h: @props.h
      source: @props.source
