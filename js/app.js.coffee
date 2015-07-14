class window.App
  constructor: ->
    @score = 0
    @stepNum = 0
    @chart = chartFactory 'chart-container'
    @moral = 100
    @pain = 0
    @startDate = new Date(2014, 2, 16)
    @curDate = @startDate
    @stepSubscribers = []
    @view = new window.AppView
    @terpenium = 100

  painSounds: [
    "ура мы дома0000.mp3",
    "3 оборона севастополя0000.mp3",
    "особая категория снабжения0000.mp3",
    "умереть в россии0000.mp3",
    "богатый турист0000.mp3",
    "зато не стреляют0000.mp3",
    "а у хохлов еще хуже0000.mp3",
    "только выиграли0000.mp3",
    "талоны на очередь0000.mp3",
    "меняйло в отставку0000.mp3",
    "путин помоги0000.mp3"
  ]

  subscribeStep: (fn) =>
    @stepSubscribers.push fn

  unsubscribeStep: (fn) =>
    @stepSubscribers = @stepSubscribers.filter (item) ->
      return item if item != fn

  fireStep: =>
    for subscriber in @stepSubscribers
      subscriber.call @stepNum

  start: ->
    @running = true
    @interval = setInterval @makeStep, 1000
    ActionManager.enableActions()
    @makeStep()
    @setSoundTimeout()

  stop: ->
    @suspend()

  suspend: ->
    @running = false
    clearInterval @interval
    ActionManager.disableActions()

  setSoundTimeout: =>
    secondsDelay = Math.floor(Math.random() * 30) + 20 # [20, 50]
    clearTimeout @soundTimeout
    @soundTimeout = setTimeout @playSoundAndRepeat, secondsDelay * 1000

  playSoundAndRepeat: =>
    if !@running
      setTimeout @playSoundAndRepeat, 30 * 1000
    else
      @playSound()
      @setSoundTimeout()

  playSound: =>
    sound_index = Math.floor(@pain / (100/@painSounds.length))
    aud         = new Audio
    aud.src     = "audio/#{@painSounds[sound_index]}"
    aud.play()

  makeStep: =>
    @stepNum++
    @curDate = new Date(@curDate.getTime() + ONE_DAY)

    @fireStep()

    # 1. ActionManager.makeStep
    @makeActionStep()
    
    # 2. calculateScores
    @calculateStepScore()

    # 3. renderScores
    @view.render()

    # 4. updateChart
    @updateChart()

  makeActionStep: =>
    # ---- delta MORAL ----
    @deltaMoral = @calculateDeltaMoral()
    @moral += @deltaMoral

    @moral = 100 if @moral > 100
    @moral = 0 if @moral < 0

    # ---- delta PAIN ----
    @deltaPain = @calculateDeltaPain()

    @pain += @deltaPain

    @checkMaxPain()
    @updateTerpenium()

    @pain = 100 if @pain > 100
    @pain = 0 if @pain < 0

  calculateDeltaPain: =>
    dpain = ActionManager.deltas.pain.shift()
    return dpain if typeof dpain != 'undefined'
    if (@moral >= 100)
      return -2
    if (@moral >= 80)
      return -1
    Math.min(-(@moral - 40) / 100, -0.15)

  calculateDeltaMoral: =>
    deltaMoral = ActionManager.deltas.moral.shift()
    if typeof deltaMoral != 'undefined'
      return deltaMoral
    if @pain == 0
      return -1
    if @moral >= 80
      return -0.25
    -0.1


  updateTerpenium: ->
    @deltaTerpenium = @calculateStepTerpenium()
    @terpenium += @deltaTerpenium

    if @terpenium > 100
      @terpenium      = 100
      @deltaTerpenium = 0

    if @terpenium <= 0
      @terpenium = 0
      @gameOver()

  gameOver: ->
    @stop()
    if @moral > 25
      modalEl = $(".finally-died")
      iframe = modalEl.find("iframe")

      ytSrc = "https://www.youtube.com/embed/" + iframe.attr("data-youtube-id")

      modalEl.off "hide.bs.modal"
      modalEl.on "hide.bs.modal", (e) =>
        iframe.attr('src', ytSrc) if iframe.length > 0

      iframe.attr('src', ytSrc + "?autoplay=1") if iframe.length > 0
      modalEl.modal("show")
    else
      $(".finally-fled").modal("show")

  calculateStepTerpenium: ->
    if @pain == 100
      return -1.5
    if @pain >= 90
      return -0.7
    if @pain >= 80
      return -0.25

    if @moral == 100
      return +1.9
    if @moral >= 90
      return +0.9
    if @moral >= 80
      return +0.5
    if @moral == 0
      return -0.45
    0


  checkMaxPain: ->
    if @pain >= 100
      @maxPainLeft = 7
    else if @maxPainLeft > 0
      @maxPainLeft = @maxPainLeft - 1

    if @maxPainLeft > 0
      @pain = 100


  updateChart: ->
    @chart.series[0].addPoint [@curDate.getTime(), @moral], true, @stepNum > 15
    @chart.series[1].addPoint [@curDate.getTime(), @pain], true, @stepNum > 15

    minEx = new Date(@curDate.getTime() - (ONE_DAY * 10))
    maxEx = new Date(@curDate.getTime() + (ONE_DAY * 3))
    @chart.xAxis[0].setExtremes(minEx, maxEx)


  calculateStepScore: ->
    @calculateLevel()

    @stepScore = (@pain * ((@level+1) * 2)) ** 2
    # if @pain == 100
    #   tmpDelta = (@stepScore ** 2) / 10
    #   @stepScore += tmpDelta

    # @stepScore = @stepScore ** (@level + 1)
    # @stepScore = @stepScore * 

    # @stepScore = @stepScore * (2 ** @level)

    level = @level + 4
    @stepScore = (@pain ** 2) * (level ** 3)

    if @pain == 100
      @stepScore = @stepScore * 8

    @maxStepScore = ((@pain * 3) ** 4) ** (@level + 1)

    @score += @stepScore

  levels: [
    0,             # не севастополец
    3500000,        # подпиндосник
    100000000,      # аксенов
    500000000,     # чалый
    1000000000,    # меняйло
    50000000000,  # путин
    100000000000 # говномидас
  ].reverse()

  calculateLevel: ->
    lev = @level

    @level = Math.round(
      Math.pow(
        Math.max(0, (@score - 10000) / 3),
        1/10
      )
    ) - 2
    @level = Math.max(@level, 0)

    for v, i in @levels
      if @score >= v
        @level = @levels.length - i - 1
        if @level != lev
          console.log "NEW LEVEL #{@level} | #{v}"
        break



window.ONE_DAY = 86400000


$ ->
  window.app = new App
  $(".start-game").click ->
    $(this).hide()
    app.start()
    app.playSound()


