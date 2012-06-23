#take all the fb json and do something with it

window.suck_down_feed = (json)->
  for x in json
    console.log(x)
