window.disable_scroll = ->
  window.addEventListener "DOMMouseScroll", wheel, false  if window.addEventListener
  window.onmousewheel = document.onmousewheel = wheel
  document.onkeydown = keydown