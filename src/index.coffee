
creator = require './creator'
store   = require './store'

button  = require './elements/button'
check   = require './elements/check'
input   = require './elements/input'
rect    = require './elements/rect'
text    = require './elements/text'

exports.createComponent   = creator.create
exports.createStore       = store.create
exports.dispatch          = store.dispatch

exports.elements =
  button: button
  check:  check
  input:  input
  rect:   rect
  text:   text
