class window.AppView
   constructor: ->
     @el = $("body")
     @scoreView = new window.ScoreView @el.find(".scores-container")
     @faceView = new window.FaceView @el.find(".face-container")

   render: ->
     @scoreView.render()
     @faceView.render()


class window.ScoreView
  constructor: (el) ->
    @el = el

    @r = new Rainbow()
    @r.setSpectrum "779dff", "red"
    @r.setNumberRange 0, 10000

  render: =>
    @el.find("#moral .val").html "#{Math.round app.moral} %"
    @el.find("#pain .val").html  "#{Math.round app.pain} %"
    @el.find("#score .val").html "#{app.score.format 0, 3, " "} руб"
    @el.find("#score .val").css "color", "#" + @r.colourAt(app.stepScore)


class window.FaceView
  constructor: (el) ->
    @el = el

  render: =>
    moral = Math.floor(app.moral / 10) * 10
    pain  = Math.floor(app.pain  / 10) * 10

    face = @el.find "img#face"
    face.attr "class", ""
    face.addClass "moral-#{moral}"
    face.addClass "pain-#{pain}"
