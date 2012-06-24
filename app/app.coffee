#the file with all the ui stuff

Feed.fetch()
FeedList.fetch()
Image.fetch()
Friends.fetch()

#individual feed item


#aggregate feed holder
class feedHolder extends Spine.Controller
  tag: "div.column"
  
  proxied: [ "render", "addall" ]

  events: 
    "click .bullhorn": "speak_all"
    
  elements: 
    ".holder": "holder"

  constructor: ->
    super
    @addall()
  
  speak_all: ->
    window.speak_all(@item)

  render: ->
    elements = $("#listTmpl").tmpl( @item )
    @el.html elements
    @refreshElements()
    @el.data "id", @item.id
    #@el.find(".datepicker").datepicker constrainInput: true
    this

  addall: ->
    console.log("add all")
    
    @holder.html("")
    for feed in Feed.findAllByAttribute("tag", @item.tag)
      r = $("#feedTmpl").tmpl( feed )
      @holder.append(r)

#holder of all the holders
class listHolder extends Spine.Controller
  el: "#columns"
  proxied: [ "addone", "addall" ]

  constructor: ->
    super
    @addall()

  addall: ->
    console.log("add all listall")
    
    @el.html ""
    for feedList in FeedList.all()
      list = new feedHolder(item: feedList)
      @el.append( list.render().el )
      list.addall()
      
  addone: (list)->
    list = new feedHolder(item: list)
    @el.append( list.render().el )
    list.addall()
    
    setTimeout("window.list_holder.addall()", 3000)

$ ->
  window.list_holder = new listHolder()
 
  if localStorage.accessToken
    $("#loading").hide()
  
  chrome.tts.stop()

  if FeedList.all().length is 0
    FeedList.create( name: "Newfeed", "tag": "stream" )
    FeedList.create( name: "Your Wall", "tag": "wall" )
  
  for x in Friends.all()
    $("#friendpicker").append("<option value='#{x.id}'>#{x.name}</option>")
  
  $(".chzn-select").chosen();


window.fb_selector = ()->

  $('#myModal').modal({})
  
  #$(".chozenSelect").val();

window.add_column = ()->
  console.log("called add column")
  
  $('#myModal').modal('hide')
  
  name = $("#column_name").val()
  user_ids = $(".chzn-select").val()
  
  f = FeedList.create( name: name, tag: name )
  window.list_holder.addone(f)
  
  for id in $(".chzn-select").val()
    url = "/#{ id }/feed"
    a = url: url
    
    console.log(url)
    window.fb_call( a, suck_down_feed, name )
    
window.stop_talking = () ->
  console.log("stop talking")
  
  chrome.tts.stop()

window.logout = () ->
  localStorage.accessToken = ""
  $("#loading").show()
  
exports = this
exports.feedHolder = feedHolder