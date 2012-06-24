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

    for feed in Feed.all()
      r = $("#feedTmpl").tmpl( feed )
      console.log(r)
      @el.append(r)

$ ->
  new feedHolder()
  
exports = this
exports.feedHolder = feedHolder