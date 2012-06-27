(function() {
  window.disable_scroll = function() {
    if (window.addEventListener) {
      window.addEventListener("DOMMouseScroll", wheel, false);
    }
    window.onmousewheel = document.onmousewheel = wheel;
    return document.onkeydown = keydown;
  };
}).call(this);
