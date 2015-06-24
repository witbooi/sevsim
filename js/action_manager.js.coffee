class window.ActionManager
  @deltas = moral: [], pain: []
  @actions = []
  @actionsStock = []
  @flags = {}

  @enableActions: =>
    for a in @actions
      a.enable()

  @disableActions: =>
    for a in @actions
      a.disable()

  @stockFull: =>
    @actionsStock = _.shuffle @actionsStock
    for i in [0..14]
      @takeActionFromStock()

    ActionManager.render()

  @takeActionFromStock: =>
    @actions.push @actionsStock.pop()
    @render()


  @addDeltas: (type, deltas) ->
    for delta, i in deltas
      if @deltas[type][i]?
        @deltas[type][i] += delta
      else
        @deltas[type][i] = delta

  @getTemplate: =>
    s = """
      <% disabled = (window.app.running && (a.available == true)) ? '' : 'disabled=\"disabled\"' %>
        <% timesLeft = a.timesLeft() > 0 ? a.timesLeft() : '' %>
        <% btnClass = a.rank() == 'positive' ? 'btn-primary' : 'btn-danger' %>
        <% title = a.title.replace(/\\\"/g,'&quot;') %>
      <button type=\"button\" data-action-id=\"<%= a.id %>\" id=\"action-<%= a.id %>-btn\" class=\"action-btn btn <%= btnClass %> \" <%= disabled %> title=\"<%= title%>\">
        <nobr><%= title %></nobr>
        <span class="times-left"><%= timesLeft %></span>
      </button>
      """
    @actionTemplate = _.template(s)

  @el = $("<div id='actions-container'></div>")

  @render: =>
    _render = () =>
      _.each(@actions, (a) => @el.append a.render().el)
      $("#actions-container").replaceWith(@el)

    if @actionTemplate?
      _render()
    else
      $.when(@getTemplate()).done => _render()

    this

  @actionById: (actId) =>
    r = _.findWhere @actions, {id: actId}
    return r if r?
    _.findWhere @actionsStock, {id: actId}

  @callbacks:
    invoke:
      {}

class window.Action
  constructor: (params) ->
    { @dmoral, @dpain, @title, @available, @intervalSteps, @id, @timesLimit, @alive, @enables, @disables } = params
    @lastUsedAtStep = 0
    @timesUsed      = 0

    @deltas       = moral: @dmoral, pain: @dpain
    @deltas.moral = [@deltas.moral] unless @deltas.moral instanceof Array
    @deltas.pain  = [@deltas.pain] unless @deltas.pain instanceof Array

    @available = true
    @elId      = "action-#{@id}"
    @el        = $("<div class   = 'action' id = '#{@elId}'></div>")

    if @enables != ""
      ActionManager.callbacks.invoke[@id] = () =>
        return false if @timesUsed > 1
        ActionManager.actionById(@enables).engage()
        @notifyEnabled ActionManager.actionById(@enables)

    if @disables != ""
      ActionManager.callbacks.invoke[@id] = () =>
        return false if @timesUsed > 1
        ActionManager.actionById(@disables).dismiss()
        @notifyDisabled ActionManager.actionById(@disables)

  notifyEnabled: (action) =>
    new PNotify
      title: ''
      text: "Теперь ты можешь #{action.title.uncapitalizeFirstLetter()}"
      type: 'info'
      icon: false

  notifyDisabled: (action) =>
    new PNotify
      title: ''
      text: "Теперь ты не можешь #{action.title.uncapitalizeFirstLetter()}"
      type: 'error'
      icon: false

  render: =>
    @el.hide() if @alive == false & @fading != true
    @el.html(ActionManager.actionTemplate({a: this}))
    @el.find(".action-btn").on "click", (e) => @invoke e
    this

  enable: =>
    @el.find(".btn").removeAttr("disabled")

  disable: =>
    @el.find(".btn").attr("disabled", "disabled")

  invoke: (e) =>
    @timesUsed++
    @lastUsedAtStep = app.stepNum

    @addDeltas()

    if ActionManager.callbacks.invoke[@id]?
      fn = ActionManager.callbacks.invoke[@id]
      fn.apply()

    story = StoryManager.create this

    @suspend() if @shouldSuspend()
    @dismiss() if @shouldDismiss()

    @render()

  shouldSuspend: =>
    return true if app.stepNum <= @lastUsedAtStep + @intervalSteps and @intervalSteps > 0
    false

  shouldDismiss: =>
    return true if @timesUsed >= @timesLimit and @timesLimit > 0
    false

  dismiss: =>
    @alive = false
    @available = false
    @el.fadeOut 500, () =>
      @el.remove()
      delete this
      ActionManager.takeActionFromStock()
    @fading = true

  engage: =>
    @available = true
    @alive = true
    @el.fadeIn()
    @render()

  suspend: =>
    @available = false
    app.subscribeStep @checkAvailability

  resume: =>
    @available = true

  checkAvailability: =>
    if not @shouldSuspend()
      @resume()
      app.unsubscribeStep @checkAvailability
      @render()

  addDeltas: =>
    ActionManager.addDeltas 'moral', @deltas.moral
    ActionManager.addDeltas 'pain', @deltas.pain

  timesLeft: =>
    @timesLimit - @timesUsed

  rank: =>
    tmp = @totalDelta('pain') - @totalDelta('moral')
    if tmp < 0
      "positive"
    else
      "negative"

  totalDelta: (type) =>
    tmp = if @deltas[type] instanceof Array
      _.reduce(
        @deltas[type]
        (a, b) -> a + b
        0
      )
    else
      @deltas[type]

