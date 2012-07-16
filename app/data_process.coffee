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

    #console.log(data)
    
    data["tag"] = tag if tag?
    data["unread"] = true
    
    if Feed.findByAttribute("id", x["id"])?
      console.log(".")
    else
      Feed.create(data)
      
  #render if it's new or if you are pulling new info
  if FeedList.findByAttribute("tag", tag)
    a = FeedList.findByAttribute("tag", tag)
    a.save()

  window.all_pulled.ok() if window.all_pulled?

window.suck_down_friends = (json) ->

  for x in json.data
    data = {}

    for field in Friends.attributes
      data[field] = x[field] if x[field]?
      
    if Friends.findByAttribute("id", x["id"])?
      console.log("this friend is already there")
    else
      Friends.create(data)

  for x in Friends.all()
    $("#friendpicker").append("<option value='#{x.id}'>#{x.name}</option>")

window.suck_down_me = (data) ->
  
  if Me.all().length is 0
    Me.create( name: data.name, id: data.id )
  else
    a = Me.first()
    a.name = data.name
    a.id = data.id
    a.save()

window.get_stream = ()->
  console.log("all pulled", window.all_pulled)
  window.all_pulled.wait() if window.all_pulled?
  window.fb_call( fb_match.newsfeed, suck_down_feed, "stream" )
  
window.get_wall = ()->
  window.all_pulled.wait() if window.all_pulled?
  window.fb_call( fb_match.wall, suck_down_feed, "wall" )
  
window.get_friends = () ->
  window.all_pulled.wait() if window.all_pulled?
  window.fb_call( fb_match.friends, suck_down_friends)

window.get_me = () ->
  console.log("get me called")
  window.all_pulled.wait() if window.all_pulled?
  window.fb_call( fb_match.me, suck_down_me)

window.get_friend_list = (feed_list) ->

  console.log("all pulled", window.all_pulled)

  list = JSON.parse( feed_list.content )

  for id in list
    if id is ""
      console.log("empty id, need to remove these")
    else  
      url = "/#{ id }/feed"
      a = url: url
      
      console.log("calling", url)
      window.all_pulled.wait() if window.all_pulled?
      window.fb_call( a, suck_down_feed, feed_list.tag )  

window.refresh_column = ( feed_list ) ->
  console.log("refresh column called")

  #"friends", "newstream", "wall", "messages" 
  switch feed_list.type
    when "friends" then window.get_friend_list(feed_list)
    when "newstream" then window.get_stream()
    when "wall" then window.get_wall()
    when "messages" then console.log("messages")
    else console.log("feed_list is not suppose to be this type", feed_list.type)

window.speak_feed = (f) ->
  rate = Settings.find("speaking-speed").value

  if f.type is "status" or f.type is "video"
    speak = name if f.name?
    speak = f.message if f.message?
    speak = f.story if f.story?

    if f["to&name"]?
      chrome.tts.speak(f["from&name"] + " said to " + f["to&name"] + " " + speak + ".", {'enqueue': true, 'rate': rate } ) 
      console.log("SPEAKING:", f["from&name"] + " said to " + f["to&name"] + " " + speak + ".")
    else
      chrome.tts.speak(f["from&name"] + " said " + speak + ".", {'enqueue': true, 'rate': rate } ) 
      console.log("SPEAKING:", f["from&name"] + " said " + speak + ".")
      
  else if f.type is "link"
    speak = f.name if f.name?
    
    if f.story?      
      chrome.tts.speak(f.story + " "+f.name, {'enqueue': true} ) 
      console.log(f.story + " "+f.name)
    else if f["to&name"]?
      chrome.tts.speak(f["from&name"] + " posted a link to " + f["to&name"] + " " + speak + ".", {'enqueue': true, 'rate': rate } ) 
      console.log(f["from&name"] + " posted a link to " + f["to&name"] + " " + speak + ".")
    else
      chrome.tts.speak(f["from&name"] + " posted a link: " + speak + ".", {'enqueue': true, 'rate': rate } ) 
      console.log("SPEAKING:", f["from&name"] + " said " + speak + ".")
  
  else if f.type is "photo" or f.type is "swf"
    
    type = "flash" if f.type is "swf"
    type = "photo" if f.type is "photo"
      
    if f.message?
      speak = f.message 
    
      chrome.tts.speak(f["from&name"] + " posted a #{type} with the message: " + speak + ".", {'enqueue': true, 'rate': rate } ) 
      console.log(f["from&name"] + " posted a #{type} with the message: " + speak + ".", {'enqueue': true, 'rate': rate }) 
    
    else if f.story?
      speak = f.story
      chrome.tts.speak(speak, {'enqueue': true, 'rate': rate } ) 
      console.log(speak)

#speaking stuff
window.speak_all = ( feed_list )->
  chrome.tts.speak("starting") 
  for f in Feed.findAllByAttribute("tag", feed_list.tag).sort(Feed.ordersort)
    window.speak_feed(f)

window.speak_all_feeds = ( feeds )->
  chrome.tts.speak("starting") 
  for f in feeds
    window.speak_feed(f)
