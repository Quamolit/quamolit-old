
_ = require 'lodash'

Component = require './component'

tool = require './util/tool'
time = require './util/time'

makeIdFrom = (options, props, base) ->
  return props.id if props?.id?
  # generate id as: c.base.id + (props.key or base.index)
  index = props?.key or base.index
  "#{base.id}/#{options.name}.#{index}"

exports.fillList = fillList = (list) ->
  list.map (a) -> a or create
    category: 'shape'
    getName: -> 'invisible'
    render: -> -> type: 'invisible'

exports.create = create = (options) ->
  # call this in side render
  (layout, props, children...) ->
    # call this when parent is computed
    (base, manager) ->
      options.props = props
      id = makeIdFrom options, props, base
      # shape uses children, base.children may be used in render()
      base.children = fillList children
      c = manager.vmDict[id]
      if c?
        # console.info 'touching', id
        c.checkBase base
        c.checkProps props
        _.assign c,
          # base will change over time due to changing state
          base: base
          layout: layout
        unless c.period is 'delay'
          c.internalRender()
      else
        c = new Component
          manager: manager
          id: id
          base: base
          props: props
          layout: layout
          options: options

        manager.vmDict[id] = c
        # bind method to a working component
        tool.bindMethods c
        if c.category is 'shape'
          c.setPeriod 'stable'
          c.internalRender()
        else if base.id in manager.existingVmIds
          console.log "found base: \t #{id} #{base.id}"
          c.setPeriod 'entering'
          c.internalRender()
        else if c.getDelay() < 5
          console.info 'delay too short'
          c.setPeriod 'entering'
          c.internalRender()
        else
          console.log "no base: \t #{id}"
          c.setPeriod 'delay'

      c.touchTime = manager.touchTime
      return c
