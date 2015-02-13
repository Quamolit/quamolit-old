
creator = require '../creator'

rect = require '../elements/rect'
text = require '../elements/text'

nativeAlpha  = require '../natives/alpha'
nativeSave   = require '../natives/save'
nativeScale  = require '../natives/scale'

module.exports = creator.create
  name: 'scale'

  getKeyframe: ->
    {}

  getEnteringKeyframe: ->
    @getKeyframe()

  getLeavingKeyframe: ->
    @getKeyframe()

  render: ->
    before = [
      nativeSave {}, {}
      nativeScale {}, @props
    ]
    @base.x = 0
    @base.y = 0
    after = [
      @base.children
      nativeRestore {}, {}
    ]
    before.concat after
