class window.App
  constructor: ->
    @score = 0
    @stepNum = 0
    @chart = chartFactory 'chart-container'
    @moral = 100
    @pain = 0
    @curDate = new Date(2014, 2, 16)
    @stepSubscribers = []

  subscribeStep: (fn) =>
    @stepSubscribers.push fn

  unsubscribeStep: (fn) =>
    @stepSubscribers = @stepSubscribers.filter (item) ->
      return item if item != fn

  fireStep: =>
    for subscriber in @stepSubscribers
      subscriber.call @stepNum

  start: ->
    @interval = setInterval @makeStep, 500
    @makeStep()

  stop: ->
    clearInterval @interval


  makeStep: =>
    @stepNum++
    @curDate = new Date(@curDate.getTime() + ONE_DAY)

    @fireStep()

    # 1. ActionManager.makeStep
    @makeActionStep()
    
    # 2. calculateScores
    @score += @calculateStepScore()

    # 3. renderScores
    @updateScores()

    # 4. updateChart
    @updateChart()

  makeActionStep: =>
    deltaMoral = ActionManager.deltas.moral.shift()
    if typeof deltaMoral == 'undefined'
      @moral -= 0.1
    else
      @moral += deltaMoral

    @moral = 100 if @moral > 100
    @moral = 0 if @moral < 0

    deltaPain = ActionManager.deltas.pain.shift()
    if typeof deltaPain == 'undefined'
      deltaPain = @moral >= 80 ? -1 : -0.2
      @pain -= deltaPain
    else
      @pain += deltaPain

    @pain = 100 if @pain > 100
    @pain = 0 if @pain < 0


  updateScores: ->
    $("#moral .val").html "#{Math.round @moral} %"
    $("#pain .val").html  "#{Math.round @pain} %"
    $("#score .val").html "#{Math.round @score} руб"


  updateChart: ->
    @chart.series[0].addPoint [@curDate.getTime(), @moral], true, @stepNum > 10
    @chart.series[1].addPoint [@curDate.getTime(), @pain], true, @stepNum > 10

    minEx = new Date(@curDate.getTime() - (ONE_DAY * 10))
    maxEx = new Date(@curDate.getTime() + (ONE_DAY * 3))
    @chart.xAxis[0].setExtremes(minEx, maxEx)


  calculateStepScore: ->
    @pain * 3


window.ONE_DAY = 86400000


$ ->
  window.app = new App
  app.start()
