
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

  render: -> [
    nativeSave {}, {}
    nativeTransform {}, @props
    @base.children
    nativeRestore {}, {}
  ]
