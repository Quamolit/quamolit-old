
_ = require 'lodash'
painter = require 'quamolit-painter'

time = require './util/time'
tool = require './util/tool'
dom = require './util/dom'

module.exports = class Manager
  constructor: (options) ->
    @node = options.node
    @handleEvents()
    @vmDict = {}
    @vmList = []

  getViewport: ->
    # get node geomerty
    id: ''
    index: 0
    z: [0]
    x: Math.round (@node.width / 2)
    y: Math.round (@node.height / 2)

  updateVmList: ->
    list = _.map @vmDict, (knot, id) -> knot
    @vmList = list
    .filter (knot) ->
      knot.category is 'shape'
    .sort (a, b) ->
      tool.compareZ a.base.z, b.base.z

  findDroppingNodes: (changeId) ->
    Object.keys(@vmDict).forEach (id) =>
      child = @vmDict[id]
      if child.category is 'shape'
        return no if child.touchTime is @touchTime
        child.setPeriod 'leaving'
      else
        return no if child.category isnt 'component'
        return no if child.touchTime >= @touchTime
        return no if child.period is 'leaving'
        console.info 'leaving', id
        if child.base.id in @existingVmIds
          child.keyframe = child.getLeavingKeyframe()
          child.setPeriod 'leaving'
        else
          child.setPeriod 'postpone'

  render: (factory) ->
    # knots are binded to @vmDict directly
    requestAnimationFrame =>
      @render factory

    @existingVmIds = Object.keys(@vmDict).filter((id) => @vmDict[id]?.touchTime >= @touchTime)

    now = time.now()
    @touchTime = now
    factory @getViewport(), @

    _.each @vmDict, (child, id) =>
      # vm already removed might appear
      return unless child?
      if child.category is 'shape'
        switch child.period
          when 'leaving'  then @handleLeavingShapes child, now
      if child.category is 'component'
        switch child.period
          # remove out date elements
          when 'leaving'  then @handleLeavingNodes  child, now
          # animate components
          when 'entering' then @handleEnteringNodes child, now
          when 'changing' then @handleChangingNodes child, now
          when 'delay'    then @handleDelayNodes    child, now
          when 'postpone' then @handlePostponeNodes child, now
        if child.jumping  then @handleJumpingNodes  child, now
    @paintVms()
    @findDroppingNodes()

  handleLeavingNodes: (c, now) ->
    if now - c.cache.frameTime > c.getDuration()
      console.info 'deleting', c.id
      tool.evalArray c.onDestroyCalls
      tool.writeIdToNull @vmDict, c.id
    else
      @updateVmFrame c, now
      c.internalRender()

  handleLeavingShapes: (c, now) ->
    if c.touchTime < @touchTime
      console.log 'leaving shape outdated:', c.id
      tool.writeIdToNull @vmDict, c.id

  handleEnteringNodes: (c, now) ->
    if (now - c.cache.frameTime) > c.getDuration()
      c.frame = c.keyframe
      c.setPeriod 'stable'
    else
      @updateVmFrame c, now

  handleChangingNodes: (c, now) ->
    if (now - c.cache.frameTime) > c.getDuration()
      c.frame = c.keyframe
      c.setPeriod 'stable'
    else
      @updateVmFrame c, now

  handleDelayNodes: (c, now) ->
    if (now - c.cache.frameTime) > c.getDelay()
      c.keyframe = c.getKeyframe()
      c.setPeriod 'entering'

  handlePostponeNodes: (c, now) ->
    if (now - c.cache.frameTime) > c.getDelay()
      c.keyframe = c.getLeavingKeyframe()
      c.setPeriod 'leaving'
    else
      console.log (now - c.cache.frameTime), c.getDelay()

  handleJumpingNodes: (c, now) ->
    if (now - c.cache.areaTime) > c.getDuration()
      c.jumping = no
    else
      @updateVmArea c, now

  updateVmFrame: (c, now) ->
    ratio = (now - c.cache.frameTime) / c.getDuration()
    c.frame = tool.computeTween c.cache.frame, c.keyframe, ratio, c.getBezier()

  updateVmArea: (c, now) ->
    ratio = (now - c.cache.areaTime) / c.getDuration()
    newArea = tool.combine c.base, c.layout
    area = tool.computeTween c.cache.area, newArea, ratio, c.getBezier()
    c.area = area

  paintVms: ->
    @updateVmList()
    @geomerties = {}
    geomerties = @vmList
    .map (shape) =>
      @geomerties[shape.id] = shape.canvas
      shape.canvas
    .filter _.isObject
    # console.log 'paint:', geomerties
    painter.paint geomerties, @node

  handleEvents: ->
    @node.addEventListener 'click', (event) =>
      x = event.offsetX
      y = event.offsetY
      ev =
        bubble: yes
        x: x
        y: y
      for vm in @vmList.concat().reverse()
        if vm.coveredPoint x, y
          if event.metaKey
          then console.log vm
          else vm.onClick? ev
        break unless ev.bubble

  createExternalElement: (id, tag, text) ->
    dom.createInput
      rect: @node.getBoundingClientRect()
      text: text
      onChange: (event) =>
        @vmDict[id].onChange event
