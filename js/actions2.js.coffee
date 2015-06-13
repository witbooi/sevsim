$ =>
  addAction = (data) =>
    xkeys = ["id", "title", "dpain", "dmoral", "intervalSteps", "timesLimit", "alive", "enables", "disables"]
    for item in data
      d = {}
      for key in xkeys
        d[key] = item[key]
      a = new Action(d)
      window.ActionManager.actionsStock.push a
    window.ActionManager.stockFull()

  addAction window.actionsSrc
