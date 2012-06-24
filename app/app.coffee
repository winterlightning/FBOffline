#the file with all the ui stuff

Feed.fetch()
FeedList.fetch()
Image.fetch()

#individual feed item


#aggregate feed holder
class feedHolder extends Spine.Controller
  tag: "div.column"
  
  proxied: [ "render", "addall" ]
  
  elements: 
    ".holder": "holder"

  constructor: ->
    super
    @addall()

  render: ->
    elements = $("#listTmpl").tmpl( @item )
    @el.html elements
    @refreshElements()
    @el.data "id", @item.id
    #@el.find(".datepicker").datepicker constrainInput: true
    this

  addall: ->
    console.log("add all")

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
  new listHolder()

  if FeedList.all().length is 0
    FeedList.create( name: "Newfeed", "tag": "stream" )
    FeedList.create( name: "Your Wall", "tag": "wall" )
  
exports = this
exports.feedHolder = feedHolder