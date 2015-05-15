window.ActionManager.actions.push new Action(
    id: 'olivier'
    title: 'Раздать оливье'
    dpain: 0
    dmoral: +25
    available: true
    intervalSteps: 10
  )

window.ActionManager.actions.push new Action(
    id: 'bridge'
    title: 'Объявить о начале строительства моста'
    dpain: 0
    dmoral: 10
    available: true
    intervalSteps: 5
    timesLimit: 4
  )

window.ActionManager.actions.push new Action(
    id: 'fire-emergency'
    title: 'Уволить скорую помощь'
    dpain: +15
    dmoral: -5
    available: true
    timesLimit: 1
  )

window.ActionManager.actions.push new Action(
    id: 'center-music'
    title: 'Включить патриотическую музыку по центру города'
    dpain: +10
    dmoral: +5
    available: true
    intervalSteps: 15
  )

$ => ActionManager.render()

