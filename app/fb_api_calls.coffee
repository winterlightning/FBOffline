#api call data
window.fb_match = 
  profile:
    url: "/me"
    method: "GET"

  newsfeed:
    url: "/me/home"
    method: "GET"
    
  wall:
    url: "/me/feed"
    method: "GET"

window.fb_base = "https://graph.facebook.com"

window.fb_call = ( obj, cb, tag ) ->
  params = {}
  #params.method = obj.method
  params.access_token = localStorage.accessToken
  
  $.getJSON("https://graph.facebook.com"+obj.url, params, (res)-> 
    console.log(res) 
    window.fb_data = res
    
    if cb?
      if tag?
        cb(res, tag)
      else
        cb(res) 
  )