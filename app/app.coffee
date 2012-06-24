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

  constructor: ->
    super
    @addall()

  addall: ->
    console.log("add all listall")

    for feedList in FeedList.all()
      list = new feedHolder(item: feedList)
      @el.append( list.render().el )
      list.addall()

$ ->
  window.list_holder = new listHolder()
 
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
  
  FeedList.create( name: name, tag: name )
  
  for id in $(".chzn-select").val()
    url = "/#{ id }/feed"
    a = url: url
    
    console.log(url)
    window.fb_call( a, suck_down_feed, name )
    
  
exports = this
exports.feedHolder = feedHolder