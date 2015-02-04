
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

  markLeavingVms: (changeId) ->
    Object.keys(@vmDict).forEach (id) =>
      child = @vmDict[id]
      if child.category is 'shape'
        return no if child.touchTime >= @touchTime
        console.log 'shape is leaving', id
        tool.writeIdToNull @vmDict, id
      else
        return no if child.category isnt 'component'
        return no if child.touchTime >= @touchTime
        return no if child.period is 'leaving'
        console.info 'leaving', id
        child.setPeriod 'leaving'
        child.keyframe = child.getLeavingKeyframe()

  render: (factory) ->
    # knots are binded to @vmDict directly
    requestAnimationFrame =>
      @render factory

    now = time.now()
    @touchTime = now
    factory @getViewport(), @

    _.each @vmDict, (child, id) =>
      # vm already removed might appear
      return unless child?
      # canvas has no lifecycle
      return unless child.category is 'component'
      switch child.period
        # remove out date elements
        when 'leaving'  then @handleLeavingNodes  child, now
        # animate components
        when 'entering' then @handleEnteringNodes child, now
        when 'changing' then @handleChangingNodes child, now
      if child.jumping  then @handleJumpingNodes  child, now
    @paintVms()
    @markLeavingVms()

  handleLeavingNodes: (c, now) ->
    if now - c.cache.frameTime > c.getDuration()
      console.info 'deleting', c.id
      tool.evalArray c.onDestroyCalls
      tool.writeIdToNull @vmDict, c.id
    else
      @updateVmFrame c, now
      c.internalRender()

  handleEnteringNodes: (c, now) ->
    if (now - c.cache.frameTime) > c.getDuration()
      @frame = @keyframe
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
