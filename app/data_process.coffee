#take all the fb json and do something with it

window.suck_down_feed = (json)->
  for x in json.data
    data = {}
    
    for field in Feed.attributes
      if field.indexOf("_") is -1
        data[field] = x[field] if x[field]?
      else
        field_a = field.split("_")[0]
        field_b = field.split("_")[1]
        
        one = x[field_a]
        data[field] = one[field_b]

    console.log(data)

    Feed.create(data)
