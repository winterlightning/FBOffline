#take all the fb json and do something with it

window.suck_down_feed = (json, tag)->
  for x in json.data
    data = {}
    
    for field in Feed.attributes
      if field.indexOf("&") is -1
        data[field] = x[field] if x[field]?
      else
        field_a = field.split("&")[0]
        field_b = field.split("&")[1]
        
        if x[field_a]?
          one = x[field_a]
          data[field] = one[field_b] if one[field_b]?

        if field_a is "to" and x[field_a]?
          console.log("got here")
          one = x[field_a]
          two = one["data"][0]
          data[field] = two[field_b] if two[field_b]?

    console.log(data)
    
    data["tag"] = tag if tag?
    
    if Feed.findByAttribute("id", x["id"])?
      console.log("this feed is already there")
    else
      Feed.create(data)
      
    #render if it's new'
    if FeedList.findByAttribute("name", tag)
      a = FeedList.findByAttribute("name", tag)
      a.save()
    
    window.list_holder.addall()

window.suck_down_friends = (json) ->

  for x in json.data
    data = {}

    for field in Friends.attributes
      data[field] = x[field] if x[field]?
      Friends.create(data)

window.get_stream = ()->
  window.fb_call( fb_match.newsfeed, suck_down_feed, "stream" )
  
window.get_wall = ()->
  window.fb_call( fb_match.wall, suck_down_feed, "wall" )
  
window.get_friends = () ->
  window.fb_call( fb_match.friends, suck_down_friends)


  
#takes in a url, and then store that image offline
window.suck_in_image = (url)->
  console.log("suck in image")
  
  $.ajax(
    url: url
    cache: false
  ).done (result) ->
    console.log result 
    Image.create( name: url, image: result )  
  
  
window.getBase64Image = (img) ->
  canvas = document.createElement("canvas")
  canvas.width = img.width
  canvas.height = img.height
  ctx = canvas.getContext("2d")
  ctx.drawImage img, 0, 0
  dataURL = canvas.toDataURL("image/png")
  dataURL.replace /^data:image\/(png|jpg);base64,/, ""
  
  Image.create( name: img.src, image: dataURL ) 

window.speak_all = ( feed_list )->
  chrome.tts.speak("starting") 
  for f in Feed.findAllByAttribute("tag", feed_list.tag)
    if f.type is "status"
      speak = f.message if f.message?
      speak = f.story if f.story?
      speak = name if f.name?
    
      chrome.tts.speak(f["from&name"] + " said " + speak + ".", {'enqueue': true} ) 
