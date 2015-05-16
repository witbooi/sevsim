class window.ActionManager
  @deltas = moral: [], pain: []
  @actions = []

  @addDeltas: (type, deltas) ->
    for delta, i in deltas
      if @deltas[type][i]?
        @deltas[type][i] += delta
      else
        @deltas[type][i] = delta

  @getTemplate: =>
    $.get "/templates/action.tpl", (resp) => @actionTemplate = _.template(resp)

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
    _.findWhere @actions, {id: actId}



class window.Action
  constructor: (params) ->
    { @dmoral, @dpain, @title, @available, @intervalSteps, @id, @timesLimit } = params
    @lastUsedAtStep = 0
    @timesUsed      = 0


    @deltas         = moral: @dmoral, pain: @dpain
    @deltas.moral = [@deltas.moral] unless @deltas.moral instanceof Array


    @alive          = @available
    @elId = "action-#{@id}"
    @el = $("<div class='action' id='#{@elId}'></div>")

  render: =>
    @el.html(ActionManager.actionTemplate({a: this}))
    @el.find(".action-btn").on "click", (e) => @invoke e
    this

  invoke: (e) =>
    @timesUsed++
    @lastUsedAtStep = app.stepNum

    @addDeltas()

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
    @el.remove()

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
