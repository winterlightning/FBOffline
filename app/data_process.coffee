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
      
  #render if it's new or if you are pulling new info
  if FeedList.findByAttribute("tag", tag)
    a = FeedList.findByAttribute("tag", tag)
    a.save()

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
  window.fb_call( fb_match.newsfeed, suck_down_feed, "stream" )
  
window.get_wall = ()->
  window.fb_call( fb_match.wall, suck_down_feed, "wall" )
  
window.get_friends = () ->
  window.fb_call( fb_match.friends, suck_down_friends)

window.get_me = () ->
  console.log("get me called")
  window.fb_call( fb_match.me, suck_down_me)

window.get_friend_list = (feed_list) ->
  list = JSON.parse( feed_list.content )

  for id in list
    if id is ""
      console.log("empty id, need to remove these")
    else  
      url = "/#{ id }/feed"
      a = url: url
      
      console.log("calling", url)
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

#speaking stuff
window.speak_all = ( feed_list )->
  chrome.tts.speak("starting") 
  for f in Feed.findAllByAttribute("tag", feed_list.tag).sort(Feed.ordersort)
    if f.type is "status"
      speak = f.message if f.message?
      speak = f.story if f.story?
      speak = name if f.name?
      
      if f["to&name"]?
        chrome.tts.speak(f["from&name"] + " said to " + f["to&name"] + " " + speak + ".", {'enqueue': true} ) 
        console.log("SPEAKING:", f["from&name"] + " said to " + f["to&name"] + " " + speak + ".")
      else
        chrome.tts.speak(f["from&name"] + " said " + speak + ".", {'enqueue': true} ) 
        console.log("SPEAKING:", f["from&name"] + " said " + speak + ".")
        
