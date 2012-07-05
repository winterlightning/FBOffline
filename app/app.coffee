#the file with all the ui stuff

Feed.fetch()
FeedList.fetch()
Image.fetch()
Friends.fetch()

#individual feed item

#aggregate feed holder
class feedHolder extends Spine.Controller
  tag: "div.column"
  
  proxied: [ "render", "addall", "remove" ]

  events: 
    "click .bullhorn": "speak_all"
    "click .settings": "edit_settings"
    "click .eye": "toggle_watched"
    
  elements: 
    ".holder": "holder"
    ".eye": "eye"

  constructor: ->
    super
    @item.bind("destroy", @remove)
    @item.bind("update", @rerender)
    @addall()
  
  edit_settings: ->
    console.log "settings"
    
    $("#dialog").dialog
      autoOpen: true
      width: 600
      title: "Edit Column"
      modal: true
      open: ()=>
        console.log("clicked save")
        $(".chzn-select").val(JSON.parse(@item.content) )
        $(".chzn-select").trigger("liszt:updated")
        $("#column_name").val("")      
      buttons:
        Delete: =>
          console.log("delete item called")
          @item.destroy()
          $("#dialog").dialog "close"
        Save: =>
          $(this).dialog "close"
        Cancel: ->
          $(this).dialog "close"          

    $(".chzn-select").chosen();
  
  speak_all: ->
    window.speak_all(@item)

  toggle_watched: ->
    console.log("toggle watch called")
    
    @item.watched = true
    @item.save()
    
    @eye.toggleClass("on")

  rerender: =>
    @render()
    @addall()

  render: =>
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

  remove: =>
    @el.remove()
    $('#columns').width( FeedList.all().length * 344 + 20 ) #resize

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
    $('#columns').width( FeedList.all().length * 344 + 20 )
    @el.append( list.render().el )
    list.addall()
    
$ ->
  window.list_holder = new listHolder()
 
  if localStorage.accessToken
    $("#loading").hide()
  
  chrome.tts.stop()

  if FeedList.all().length is 0
    a = FeedList.create( name: "Newfeed", "tag": "stream", "type", "newstream" )
    b = FeedList.create( name: "Your Wall", "tag": "wall", "type", "wall" )
    
    window.list_holder.addone(a)
    window.list_holder.addone(b)
  
  for x in Friends.all()
    $("#friendpicker").append("<option value='#{x.id}'>#{x.name}</option>")
  
  $(".chzn-select").chosen();
  
  $('#pane-target').width( $(window).width() )
  $('#columns').width( FeedList.all().length * 344 + 20 ) #on feedlist create, this should be enlarged
    
window.fb_selector = ()->
  $(".chzn-select").val("")
  
  $("#dialog").dialog
    autoOpen: true
    width: 600
    title: "Add Column"
    modal: true
    open: ()=>
      console.log("clicked save")
      $(".chzn-select").val("")
      $(".chzn-select").trigger("liszt:updated")
      $(".chzn-select").blur()
      $("#column_name").val("")
      
    buttons:
      Save: =>
        window.add_column()
        $("#dialog").dialog "close"
      Cancel: ->
        $(this).dialog "close"   
          
  #$(".chozenSelect").val();

window.add_column = ()->
  console.log("called add column")
  
  name = $("#column_name").val()
  user_ids = $(".chzn-select").val()
  
  f = FeedList.create( name: name, tag: name, type: "friends", content: JSON.stringify( user_ids ) )
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
  
  chrome.tabs.onUpdated.addListener onFacebookLogin
  
exports = this
exports.feedHolder = feedHolder