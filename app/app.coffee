#the file with all the ui stuff

Feed.fetch()
FeedList.fetch()
Image.fetch()
Friends.fetch()
Me.fetch()

Feed.ordersort = (a, b) ->
  (if (a.updated_time > b.updated_time) then -1 else 1)

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
        $("#column_name").val(@item.name)
        $(".chzn-select").val(JSON.parse(@item.content) )
        $(".chzn-select").trigger("liszt:updated")
        
      buttons: [ 
        text: "Delete"
        class: "btn btn-danger"
        click: =>
          console.log("delete item called")
          @item.destroy()
          $("#dialog").dialog "close"
      ,
        text: "Save"
        class: "btn btn-primary"
        click: =>
          #check if the list of people is different, if it is, pull from cloud again
          if @item.content isnt JSON.stringify( $(".chzn-select").val() )
            @item.content = JSON.stringify( $(".chzn-select").val() )
            @item.name = $("#column_name").val()
            @item.save()
            window.refresh_column( @item )
            
          #else just re-render
          else
            @rerender()
          
          $("#dialog").dialog "close"  
      ,
        text: "Cancel"
        class: "btn"
        click: ->
          $(this).dialog "close"            
      ]                    

    $(".chzn-select").chosen();
  
  speak_all: ->
    window.speak_all(@item)

  toggle_watched: ->
    console.log("toggle watch called")
    
    @item.watched = not @item.watched
    @item.save()
    
    #@eye.toggleClass("on")

  rerender: =>
    @render()
    @addall()

  render: =>
    @item = FeedList.find(@item.id)
    elements = $("#listTmpl").tmpl( @item )
    @el.html elements
    @refreshElements()
    @el.data "id", @item.id
    #@el.find(".datepicker").datepicker constrainInput: true
    this

  addall: ->
    console.log("add all")
    
    @holder.html("")
    for feed in Feed.findAllByAttribute("tag", @item.tag).sort(Feed.ordersort)
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
    a = FeedList.create( name: "Newfeed", "tag": "stream", "type":"newstream", "editable": false, "watched": true )
    b = FeedList.create( name: "Your Wall", "tag": "wall", "type":"wall", "editable": false, "watched": true )
    
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
    open: ()->
      $(".chzn-select").val("")
      $(".chzn-select").trigger("liszt:updated")
      $(".chzn-select").blur()
      $("#column_name").val("")
      
    buttons: [ 
        text: "Save"
        class: "btn btn-primary"
        click: ->
          window.add_column()
          $("#dialog").dialog "close"
      ,
        text: "Cancel"
        class: "btn"
        click: ->
          $(this).dialog "close"  
      ]      
  #$(".chozenSelect").val();

window.add_column = ()->
  console.log("called add column")
  
  name = $("#column_name").val()
  user_ids = $(".chzn-select").val()
  
  f = FeedList.create( name: name, tag: name, type: "friends", content: JSON.stringify( user_ids ), "editable": true )
  window.list_holder.addone(f)
  
  for id in $(".chzn-select").val()
    url = "/#{ id }/feed"
    a = url: url
    
    console.log(url)
    window.fb_call( a, suck_down_feed, name )

window.refresh_feed = () ->
  for x in FeedList.all()
    window.refresh_column( x )
    
window.stop_talking = () ->
  console.log("stop talking")
  
  chrome.tts.stop()

window.logout = () ->
  localStorage.accessToken = ""
  $("#loading").show()
  
  chrome.tabs.onUpdated.addListener onFacebookLogin

window.update_status_window = ()->
  console.log "update status window"
  
  $("#dialog_status").dialog
    autoOpen: true
    width: 400
    title: "Update Status"
    modal: true
    open: ()->
      $("#dialog_status_textarea").val("")
    buttons: [ 
        text: "Update"
        class: "btn btn-primary"
        click: ->
          a = $("#dialog_status_textarea").val()
          window.post_wall(Me.first().id, a)
          $(this).dialog "close"
      ,
        text: "Cancel"
        class: "btn"
        click: ->
          $(this).dialog "close"  
      ]

window.auto_pull = () ->
  
  window.all_pulled = new DelayedOp -> 
    talk_feed = Feed.findAllByAttribute("unread", true).sort(Feed.ordersort)
    
    console.log("talk_feed", talk_feed)
    
    for t in talk_feed
      window.speak_feed( t )
      t.unread = false  

  for x in FeedList.findAllByAttribute("watched", true)
    switch feed_list.type
      when "friends" then window.get_friend_list(feed_list)
      when "newstream" then window.fb_call( fb_match.newsfeed, suck_down_feed, "stream" )
      when "wall" then window.fb_call( fb_match.wall, suck_down_feed, "wall" )
      when "messages" then console.log("messages")
      else console.log("feed_list is not suppose to be this type", feed_list.type)
  
exports = this
exports.feedHolder = feedHolder