
_ = require 'lodash'

dispatcher =
  events: {}
  register: (name, cb) ->
    unless @events[name]? then @events[name] = []
    unless cb in @events[name]
      @events[name].push cb
  dispatch: (name, payload) ->
    if _.isArray @events[name]
      for cb in @events[name]
        cb payload

exports.dispatch = (name, data) ->
  dispatcher.dispatch name, data

storeMixins =
  initializeListeners: ->
    @listeners = []

  initializeActions: ->
    for name, method of @actions
      dispatcher.register name, (payload) => @[method] payload

  initializeGetters: ->
    @get = (name, query) =>
      method = @getters[name]
      @[method] query

  register: (cb) ->
    unless cb in @listeners
      @listeners.push cb

  unregister: (cb) ->
    @listeners = @listeners.filter (f) =>
      f isnt cb

  change: (data) ->
    (f data) for f in @listeners

exports.create = (options) ->
  _.assign options, storeMixins
  options.initialize()
  options.initializeListeners()
  options.initializeGetters()
  options.initializeActions()
  options
