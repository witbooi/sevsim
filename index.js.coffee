class Person
  constructor: ->
    @moral = 100
    @pain = 0


class Manager
  constructor: ->
    @score = 0
    @stepNum = 0
    @chart = chartFactory 'chart-container'


  start: ->
    console.log 'start'
    @pendingActions = []
    @p = new Person
    @interval = setInterval @makeStep, 100
    @makeStep()

  stop: ->
    clearInterval @interval

  makeStep: =>
    @stepNum++
    @performAllActions()
    @score += @calculateStepScore()

    for action in actions when action.available is false
      action.stepsSinceLast += 1
      if action.stepsSinceLast == action.intervalSteps
        action.stepsSinceLast = 0
        action.available = true

    @updateChart()
    @updateScores()

    # @stepLog()

  updateScores: ->
    $("#moral .val").html "#{@p.moral} %"
    $("#pain .val").html  "#{@p.pain} %"
    $("#score .val").html "#{@score} руб"

  updateChart: ->
    @chart.series[0].addPoint @p.moral, true, @stepNum > 50
    @chart.series[1].addPoint @p.pain, true, @stepNum > 50
    @chart.xAxis[0].setExtremes @stepNum - 40, @stepNum + 50

    # console.log [@stepNum, @stepNum - 40, @stepNum + 50]

  stepLog: ->
    console.log { step: @stepNum, moral: @p.moral, pain: @p.pain, score: @score }
    # console.log [ actions[0].available, actions[0].stepsSinceLast, actions[0].intervalSteps ]

  calculateStepScore: ->
    @p.pain * 3

  performAllActions: ->
    while action = @pendingActions.pop()
      @performAction action

  performAction: (action) ->
    @stepLog()
    console.log "Action performed: #{action.title} dmoral #{action.dmoral} dpain #{action.dpain}"
    @p.pain += action.dpain
    @p.moral += action.dmoral

    @p.pain  = 0   if @p.pain  < 0
    @p.moral = 0   if @p.moral < 0
    @p.pain  = 100 if @p.pain  > 100
    @p.moral = 100 if @p.moral > 100

    if action.intervalSteps
      action.available = false
      action.stepsSinceLast = -1

    @stepLog()
    console.log @pendingActions

class Action
  constructor: (params) ->
    { @dmoral, @dpain, @title, @available, @intervalSteps } = params
    @stepsSinceLast = 0


window.actions = []
window.actions.push new Action(
    title: 'Оливье'
    dpain: 0
    dmoral: +25
    available: true
    intervalSteps: 10
  )

window.actions.push new Action(
    title: 'Мост'
    dpain: 0
    dmoral: 10
    available: true
    intervalSteps: 5
  )

window.actions.push new Action(
    title: 'Уволить скорую'
    dpain: +15
    dmoral: -5
    available: true
    intervalSteps: 15
  )

window.actions.push new Action(
    title: 'Музыка в центре'
    dpain: +10
    dmoral: +5
    available: true
    intervalSteps: 15
  )


# console.log actions

$ ->
  window.m = new Manager
  m.start()
  $("#actions input").click (event) ->
    console.log event.target
    action = window.actions[$(event.target).attr("data-action-id")]
    console.log action
    m.pendingActions.push action
