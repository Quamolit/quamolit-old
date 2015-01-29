
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
    isViewport: true
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

  differLeavingVms: (changeId, changeTime) ->
    _.each @vmDict, (child, id) =>
      if child.category is 'shape'
        if id.indexOf("#{changeId}/") is 0
          if child.touchTime < changeTime
            tool.writeIdToNull @vmDict, id
      return if child.category isnt 'component'
      return unless tool.isComponentUnmounted @vmDict, id
      return if child.period in ['leaving', 'delayLeaving']
      return if child.touchTime >= changeTime
      if c.layout.delay
        child.setPeriod 'delayLeaving'
      else
        console.info 'leaving', id
        child.setPeriod 'leaving'
        child.keyframe = child.getLeavingKeyframe()
    @refreshVmPeriods()

  render: (factory) ->
    # knots are binded to @vmDict directly
    factory @getViewport(), @
    @refreshVmPeriods()

  refreshVmPeriods: ->
    for id, child of @vmDict
      if child.category is 'component'
        if child.period isnt 'stable'
          requestAnimationFrame @refreshVmPeriods.bind(@)
          break

    now = time.now()
    _.each @vmDict, (child, id) =>
      # vm already removed might appear
      return unless child?
      # canvas has no lifecycle
      return unless child.category is 'component'
      switch child.period
        # remove out date elements
        when 'delayLeaving'   then @handleDelayLeavingNodes child, now
        when 'leaving'        then @handleLeavingNodes  child, now
        # setup new elements
        when 'delay'          then @handleDelayNodes    child, now
        # animate components
        when 'entering'       then @handleEnteringNodes child, now
        when 'changing'       then @handleChangingNodes child, now
      if child.jumping  then @handleJumpingNodes  child, now
    @paintVms()

  handleLeavingNodes: (c, now) ->
    if now - c.cache.frameTime > c.getDuration()
      target = c.id
      _.each @vmDict, (child, id) =>
        if (id.indexOf("#{target}/") is 0) or (id is target)
          console.info 'deleting', id
          tool.evalArray child.onDestroyCalls
          tool.writeIdToNull @vmDict, id
    else
      @updateVmFrame c, now

  handleDelayLeavingNodes: (c, now) ->
    if (now - c.cache.frameTime) >= (c.layout.delay or 0)
      c.keyframe = c.getKeyframe()
      c.setPeriod 'leaving'

  handleDelayNodes: (c, now) ->
    if (now - c.cache.frameTime) >= (c.layout.delay or 0)
      c.keyframe = c.getKeyframe()
      c.setPeriod (if c.getDuration() > 0 then 'entering' else 'stable')
      tool.evalArray c.onEnterCalls

  handleEnteringNodes: (c, now) ->
    if (now - c.cache.frameTime) > c.getDuration()
      c.setPeriod 'stable'
    else
      @updateVmFrame c, now

  handleChangingNodes: (c, now) ->
    if (now - c.cache.frameTime) > c.getDuration()
      c.setPeriod 'stable'
    else
      @updateVmFrame c, now

  handleJumpingNodes: (c, now) ->
    if (now - c.cache.areaTime) > c.getDuration()
      c.jumping = no
    else
      @updateVmArea c, now

  updateVmFrame: (c, now) ->
    ratio = (now - c.cache.frameTime) / c.getDuration()
    frame = tool.computeTween c.cache.frame, c.keyframe, ratio, c.getBezier()
    c.setKeyframe frame

  updateVmArea: (c, now) ->
    ratio = (now - c.cache.areaTime) / c.getDuration()
    newArea = tool.combine c.base, c.layout
    area = tool.computeTween c.cache.area, newArea, ratio, c.getBezier()
    c.setArea area

  paintVms: ->
    @updateVmList()
    @geomerties = {}
    geomerties = @vmList
    .map (shape) =>
      @geomerties[shape.id] = shape.canvas
      shape.canvas
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
