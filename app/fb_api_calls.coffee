#api call data
window.fb_match = 
  profile:
    url: "/me"
    method: "GET"

window.fb_base = "https://graph.facebook.com"

window.fb_call = ( obj, cb ) ->
  params = {}
  params.method = obj.method
  params.access_token = localStorage.accessToken
  
  $.getJSON("https://graph.facebook.com"+obj.url, params, (res)-> 
    console.log(res) 
    cb(res) if cb?
  )