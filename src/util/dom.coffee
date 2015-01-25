
exports.createInput = (config) ->
  backdrop = document.createElement 'div'
  backdrop.className = 'quamolit-backdrop'
  rect = config.rect
  tag = document.createElement 'input'
  tag.className = 'quamolit-tag'
  tag.value = config.text
  backdrop.style.top = "#{rect.top}px"
  backdrop.style.bottom = "#{innerHeight - rect.bottom}px"
  backdrop.style.left = "#{rect.left}px"
  backdrop.style.right = "#{innerWidth - rect.right}px"
  backdrop.appendChild tag
  tag.oninput = (event) ->
    config.onChange text: event.target.value
  remove = ->
    backdrop.remove()
    backdrop = null
    tag.onkeydown = null
    tag.onchange = null
    tag = null
  tag.onkeydown = (event) =>
    if event.keyCode is 13
      remove()
  backdrop.onclick = (event) ->
    if event.target is backdrop
      remove()
  document.body.appendChild backdrop
  tag.select()
