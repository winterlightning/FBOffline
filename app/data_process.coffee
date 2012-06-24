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

window.get_stream = ()->
  window.fb_call( fb_match.newsfeed, suck_down_feed, "stream" )
  
window.get_wall = ()->
  window.fb_call( fb_match.wall, suck_down_feed, "wall" )
