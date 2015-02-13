
creator = require '../creator'

rect = require '../elements/rect'
text = require '../elements/text'

nativeSave     = require '../native/save'
nativeRestore  = require '../native/clip'

module.exports = creator.create
  name: 'clip'

  getKeyframe: ->
    {}

  getEnteringKeyframe: ->
    @getKeyframe()

  getLeavingKeyframe: ->
    @getKeyframe()

  render: -> [
    nativeSave {}, {}
    nativeClip {}, @props
    @base.children
    nativeRestore {}, {}
  ]
