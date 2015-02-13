
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

  render: ->
    before = [
      nativeSave {}, {}
      nativeAlpha {}, @props
    ]
    @base.x = 0
    @base.y = 0
    after = [
      @base.children
      nativeRestore {}, {}
    ]

    before.concat after
