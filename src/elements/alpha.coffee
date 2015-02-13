
creator = require '../creator'

rect = require '../elements/rect'
text = require '../elements/text'

nativeAlpha    = require '../native/alpha'
nativeSave     = require '../native/save'
nativeRestore  = require '../native/restore'

module.exports = creator.create
  name: 'alpha'

  getKeyframe: ->
    {}

  getEnteringKeyframe: ->
    @getKeyframe()

  getLeavingKeyframe: ->
    @getKeyframe()

  render: -> [
    nativeSave {}, {}
    nativeAlpha {}, @props
    @base.children
    nativeRestore {}, {}
  ]
