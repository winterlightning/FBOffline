#the file with all the ui stuff

Feed.fetch()

#individual feed item


#aggregate feed holder
class feedHolder extends Spine.Controller
  el: ".holder"

  constructor: ->
    super
    @addall()

  addall: ->
    console.log("add all")

    for i in Feed.all()
      @el.append("<h1>APPENEDED<h1>")

$ ->
  new feedHolder()
  
exports = this
exports.feedHolder = feedHolder