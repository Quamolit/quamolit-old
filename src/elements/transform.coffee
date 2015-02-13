
creator = require '../creator'

rect = require '../elements/rect'
text = require '../elements/text'

nativeAlpha      = require '../natives/alpha'
nativeSave       = require '../natives/save'
nativeTransform  = require '../natives/transform'

module.exports = creator.create
  name: 'rotate'

  getKeyframe: ->
    {}

  getEnteringKeyframe: ->
    @getKeyframe()

  getLeavingKeyframe: ->
    @getKeyframe()

  render: ->
    before = [
      nativeSave {}, {}
      nativeTransform {}, @props
    ]
    @base.x = 0
    @base.y = 0
    after = [
      @base.children
      nativeRestore {}, {}
    ]
    before.concat after
