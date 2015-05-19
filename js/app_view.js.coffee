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
    @el.find("#pain .val").html  "#{Math.round app.pain} %"
    @el.find("#moral .val").html "#{Math.round app.moral} %"

    @el.find("#score .val").html "#{app.score.format 0, 3, " "} руб"
    @el.find("#score .val").css "color", "#" + @r.colourAt(app.stepScore)

    levelTitle = @levels[app.level].title
    levelDesc = @levels[app.level].desc
    @el.find("#level .val").html("<b>#{levelTitle}</b>&nbsp;&ndash;&nbsp;#{levelDesc}") if levelTitle?

    @el.find("#terpenium .val").html("#{app.terpenium.format 0, 3, "", "."} %")

  levels:
    [
      {
        title: 'Даже не севастополец'
        desc: 'на тебя не обращают внимания'
      }
      {
        title: 'Подпиндосник'
        desc: 'при биндерах унижали и то лучше'
      }
      {
        title: 'Аксенов'
        desc: 'севастопольцы верят что ты лучше губернатора Севастополя, а все крымские бандиты завидуют тебе'
      }
      {
        title: 'Народный мэр Чалый'
        desc: 'музеи города мечтают заполучить твой ношеный свитер, а преданные горожане готовы идти под пули невидимых бандер с твоим именем на устах'
      }
      {
        title: 'Губернатор Меняйло'
        desc: 'на тебя работает целый департамент унижения пидорашек при правительстве города; севастопольцев еще никто так не удивлял'
      }
      {
        title: 'Путин'
        desc: 'твои люди растаптывают Крым, а ты смеешься; севастопольцы в восторге от твоей сильной руки в своих анусах и просят еще'
      }
      {
        title: 'Говномидас'
        desc: 'ты стал верховным божеством русского мира, всё, к чему ты прикоснешься, превращается в говно'
      }
    ]


class window.FaceView
  constructor: (el) ->
    @el = el

  render: =>
    moral = Math.floor(app.moral / 10) * 10
    pain  = Math.floor(app.pain  / 10) * 10

    face = @el.find "div.face"
    face.attr "class", "face"
    face.addClass "moral-#{moral}"
    face.addClass "pain-#{pain}"
