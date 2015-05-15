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
    @pendingActions = []
    @interval = setInterval @makeStep, 500
    @makeStep()


  stop: ->
    clearInterval @interval


  makeStep: =>
    @stepNum++
    @curDate = new Date(@curDate.getTime() + ONE_DAY)

    @fireStep()

    # 1. ActionManager.makeStep
    # 2. calculateScores
    # 3. renderScores
    # 4. updateChart

    @performAllActions()
    @score += @calculateStepScore()

    for action in actions when action.available is false
      action.stepsSinceLast += 1
      if action.stepsSinceLast == action.intervalSteps
        action.stepsSinceLast = 0
        action.available = true

    @updateChart()
    @updateScores()


  updateScores: ->
    $("#moral .val").html "#{Math.round @moral} %"
    $("#pain .val").html  "#{Math.round @pain} %"
    $("#score .val").html "#{Math.round @score} руб"


  updateChart: ->
    if @moralChanged
      @chart.series[0].addPoint [@curDate.getTime(), @moral], true, @stepNum > 10
    if @painChanged
      @chart.series[1].addPoint [@curDate.getTime(), @pain], true, @stepNum > 10
    minEx = new Date(@curDate.getTime() - (ONE_DAY * 10))
    maxEx = new Date(@curDate.getTime() + (ONE_DAY * 3))
    @chart.xAxis[0].setExtremes(minEx, maxEx)


  stepLog: ->
    console.log { step: @stepNum, moral: @moral, pain: @pain, score: @score }
    # console.log [ actions[0].available, actions[0].stepsSinceLast, actions[0].intervalSteps ]


  calculateStepScore: ->
    @pain * 3


  performAllActions: ->
    oldPain = @pain
    oldMoral = @moral
    if @pendingActions.length > 0
      while action = @pendingActions.pop()
        @performAction action
    else
      @moral -= 0.095
      @pain  -= 0.15

    if @moral >= 80
      @pain -= 0.3

    @pain  = 0   if @pain  < 0
    @moral = 0   if @moral < 0
    @pain  = 100 if @pain  > 100
    @moral = 100 if @moral > 100

    @moralChanged = oldMoral != @moral
    @painChanged = oldPain != @pain



  performAction: (action) ->
    @stepLog()
    console.log "Action performed: #{action.title} dmoral #{action.dmoral} dpain #{action.dpain}"
    @pain += action.dpain
    @moral += action.dmoral

    if action.intervalSteps
      action.available = false
      action.stepsSinceLast = -1

    @stepLog()
    console.log @pendingActions

window.ONE_DAY = 86400000


$ ->
  window.app = new App
  app.start()
