
exports.timeout = (t, f) ->
  setTimeout f, t

exports.interval = (t, f) ->
  setInterval f, t

exports.now = ->
  (new Date).getTime().valueOf()
