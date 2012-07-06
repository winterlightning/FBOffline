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
  
  friends:
    url: "/me/friends"

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
  
window.like_obj = (id) ->
  console.log("like obj")
  
  params = {}
  params.access_token = localStorage.accessToken
  
  url = fb_base + "/#{id}/likes"
  
  $.post url, params, (data) ->
    console.log("like done", data)

window.comment_obj = (id, message) ->
  console.log("comment obj")

  params = {}
  params.access_token = localStorage.accessToken
  params.message = message

  url = fb_base + "/#{id}/comments"

  $.post url, params, (data) ->
    console.log("comment done", data)