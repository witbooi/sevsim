class Person
  constructor: ->
    @moral = 100
    @pain = 0


class Manager
  constructor: ->
    @score = 0
    @stepNum = 0
    @chart = chartFactory 'chart-container'
    @moral = 100
    @pain = 0
    @curDate = new Date(2014, 2, 16)


  start: ->
    console.log 'start'
    @pendingActions = []
    @interval = setInterval @makeStep, 500
    @makeStep()

  stop: ->
    clearInterval @interval

  makeStep: =>
    @stepNum++
    @curDate = new Date(@curDate.getTime() + 86400000)

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
    $("#moral .val").html "#{Math.round @moral} %"
    $("#pain .val").html  "#{Math.round @pain} %"
    $("#score .val").html "#{Math.round @score} руб"

  updateChart: ->
    if @moralChanged
      @chart.series[0].addPoint [@curDate.getTime(), @moral], true, @stepNum > 10
    if @painChanged
      @chart.series[1].addPoint [@curDate.getTime(), @pain], true, @stepNum > 10
    minEx = new Date(@curDate.getTime() - (86400000 * 10))
    maxEx = new Date(@curDate.getTime() + (86400000 * 3))
    @chart.xAxis[0].setExtremes(minEx, maxEx)

    # console.log [@stepNum, @stepNum - 40, @stepNum + 50]

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

class window.ActionManager
  @deltas = moral: [], pain: []
  @addDeltas: (type, deltas) ->
    for delta, i in deltas
      if @deltas[type][i]?
        @deltas[type][i] += delta
      else
        @deltas[type][i] = delta

class Action
  constructor: (params) ->
    { @dmoral, @dpain, @title, @available, @intervalSteps } = params
    @stepsSinceLast = 0
    @deltas         = moral: [@dmoral], pain: [@dpain]

  invoke: ->
    ActionManager.addDeltas 'moral', @deltas.moral
    ActionManager.addDeltas 'pain', @deltas.pain


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
