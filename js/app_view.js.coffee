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
    @finalEl = $(".result-info")
    @rainbows =
      score: new Rainbow()
      percent: new Rainbow()

    @rainbows.score.setSpectrum "779dff", "red"
    @rainbows.score.setNumberRange 0, 10000

    @rainbows.percent.setSpectrum "779dff", "red"
    @rainbows.percent.setNumberRange 0, 100


  render: =>
    @el.find("#pain .val").html  "#{Math.round app.pain} %"
    @el.find("#pain .val").css "color", "#" + @rainbows.percent.colourAt(app.pain)

    @el.find("#moral .val").html "#{Math.round app.moral} %"

    @el.find("#score .val").html "#{app.score.format 0, 3, " "} руб"
    @el.find("#score .val").css "color", "#" + @rainbows.score.colourAt(app.stepScore)

    levelTitle = @levels[app.level].title
    levelDesc = @levels[app.level].desc
    @el.find("#level .val").html("<b>#{levelTitle}</b>&nbsp;&ndash;&nbsp;#{levelDesc}") if levelTitle?

    terpVal = @el.find("#terpenium .val")
    terpVal.removeClass "positive"
    terpVal.removeClass "negative"
    terpVal.addClass "positive" if app.deltaTerpenium > 0
    terpVal.addClass "negative" if app.deltaTerpenium < 0
    terpVal.html("#{app.terpenium.format 0, 3, "", "."} %")

    @finalEl.find(".score").text("#{app.score.format 0, 3, " "}")
    @finalEl.find(".level").text(levelTitle)
    timeDiff = Math.abs(app.curDate - app.startDate)
    diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24))
    @finalEl.find(".days").text(diffDays)
    @finalEl.find(".days-word").text(Helper.declOfNum(diffDays, ['день', 'дня', 'дней']))
    @finalEl.find(".score-word").text(Helper.declOfNum(diffDays, ['рубль', 'рубля', 'рублей']))

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
