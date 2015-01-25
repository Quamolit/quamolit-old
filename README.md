
Canvas based UI framework with transitions
----

This is an experimental project.

MVC didn't help with the gap between view and animations.
Quamolit is trying an idea on narrowing down that gap.

### Usage

* Component

```coffee
Quamolit = require 'quamolit'

cardComponent = Quamolit.createComponent
  name: 'card'
  propTypes: {}
  getKeyframe: ->
  getEnteringKeyframe: ->
  getLeavingKeyframe: ->
  onClick: (event) ->
  render: ->
```

* Store

```coffee
Quamolit = require 'quamolit'

todoStore = Quamolit.createStore
  initialize: ->
    @data = []

  actions:
    'item/add': 'add'
    'item/remove': 'remove'
    'item/toggle': 'toggle'

  getters:
    'done': 'getDone'
    'all': 'getAll'

  add: (payload) ->
  remove: (payload) ->
  toggle: (payload) ->

  getDone: ->
  getAll: ->

exports.register    = (cb) -> store.register cb
exports.unregister  = (cb) -> store.unregister cb
exports.get = (getter, payload) -> todoStore.get getter, payload
```

* Manager

```coffee
Quamolit = require 'quamolit'
{Manager} = Quamolit

pageManager = new Manager node: document.querySelector('canvas')
card = cardComponent data: 'demo'
pageManager.render card
```

### Elements

Demo of using:

```coffee
button = Quamolit.elements.button
button text: 'demo'
```

Elements currently supported:

* button
* check
* input
* rect
* text

### License

MIT
