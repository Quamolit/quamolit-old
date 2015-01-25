
_ = require 'lodash'

Component = require './component'

tool = require './util/tool'
time = require './util/time'

makeIdFrom = (options, props, base) ->
  return options.id if options.id?
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
      if manager.vmDict[id]?
        c = manager.vmDict[id]
        # console.info 'touching', id
        c.checkBase base
        c.checkProps props
        _.assign c,
          touchTime: time.now()
          # base will change over time due to changing state
          base: base
          layout: layout
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
        # console.info 'creating', id
        # bind method to a working component
        tool.bindMethods c
        c.internalRender()

      return c
