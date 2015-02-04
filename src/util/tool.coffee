
_ = require 'lodash'

exports.evalArray = (list) ->
  list?.forEach (f) -> f()

exports.bindMethods = (a) ->
  # bind method to a working component
  _.each a, (method, name) ->
    if _.isFunction method
      bindedMethod = method.bind a
      a[name] = bindedMethod
      bindedMethod.toString = -> method.toString()

exports.compareZ = compareZ = (a, b) ->
  return 0 if a.length is 0 and b.length is 0
  return -1 if a.length is 0 and b.length > 0
  return 1 if a.length > 0 and b.length is 0
  switch
    when a[0] < b[0] then -1
    when a[0] > b[0] then 1
    else compareZ a[1..], b[1..]

exports.computeTween = (a, b, ratio, bezierFn) ->
  c = {}
  keys = _.union (Object.keys a), (Object.keys b)
  keys.forEach (key) ->
    if (_.isNumber a[key]) and (_.isNumber b[key])
    then c[key] = Math.round (a[key] + (b[key] - a[key]) * (bezierFn ratio))
    else c[key] = b[key] or a[key]
  # console.log c.x, c.y
  c

exports.combine = (a, b) ->
  c = {}
  keys = _.union (Object.keys a), (Object.keys b)
  keys.forEach (key) ->
    if (_.isNumber a[key]) and (_.isNumber b[key])
    then c[key] = a[key] + b[key]
    else c[key] = b[key] or a[key]
  c

exports.writeIdToNull = (obj, id) ->
  if obj[id]?
    for key in obj[id]
      obj[id][key] = null
    obj[id] = null
    delete obj[id]
