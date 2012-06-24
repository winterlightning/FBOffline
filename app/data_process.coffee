#take all the fb json and do something with it

window.suck_down_feed = (json)->
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

    console.log(data)
    
    if Feed.findByAttribute("id", x["id"])?
      console.log("this feed is already there")
    else
      Feed.create(data)
