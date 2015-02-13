
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

  render: ->
    before = [
      nativeSave {}, {}
      nativeClip {}, @props
    ]
    @base.x = 0
    @base.y = 0
    after = [
      @base.children
      nativeRestore {}, {}
    ]
    before.concat after
