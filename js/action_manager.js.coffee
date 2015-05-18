class window.ActionManager
  @deltas = moral: [], pain: []
  @actions = []
  @actionsStock = []
  @flags = {}

  @stockFull: =>
    @actionsStock = _.shuffle @actionsStock
    for i in [0..15]
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
      <% disabled = a.available == true ? '' : 'disabled=\"disabled\"' %>
        <% timesLeft = a.timesLeft() > 0 ? a.timesLeft() : '' %>
        <% btnClass = a.rank() == 'positive' ? 'btn-primary' : 'btn-danger' %>
      <button type=\"button\" data-action-id=\"<%= a.id %>\" id=\"action-<%= a.id %>-btn\" class=\"action-btn btn <%= btnClass %> \" <%= disabled %>>
        <nobr><%= a.title.replace(/\\\"/g,'&quot;') %></nobr>
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
      ritual: =>
        @flags.ritualInvoked = true
        a = @actionById 'mass_ban'
        a.engage() unless a.alive == true
      mass_ban: =>
        @actionById('ritual').dismiss()
      vinco: =>
        a = @actionById 'boyarishnik'
        a.engage() unless a.alive == true
    

class window.Action
  constructor: (params) ->
    { @dmoral, @dpain, @title, @available, @intervalSteps, @id, @timesLimit, @alive } = params
    @lastUsedAtStep = 0
    @timesUsed      = 0


    @deltas         = moral: @dmoral, pain: @dpain
    @deltas.moral = [@deltas.moral] unless @deltas.moral instanceof Array
    @deltas.pain = [@deltas.pain] unless @deltas.pain instanceof Array


    @available = true
    @elId = "action-#{@id}"
    @el = $("<div class='action' id='#{@elId}'></div>")

  render: =>
    @el.hide() if @alive == false
    @el.html(ActionManager.actionTemplate({a: this}))
    @el.find(".action-btn").on "click", (e) => @invoke e
    this

  invoke: (e) =>
    @timesUsed++
    @lastUsedAtStep = app.stepNum

    @addDeltas()

    if ActionManager.callbacks.invoke[@id]?
      fn = ActionManager.callbacks.invoke[@id]
      fn.apply()

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
    @el.fadeOut "1000", () => @el.remove()
    delete this
    ActionManager.takeActionFromStock()

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

