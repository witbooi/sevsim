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
    dpain: 15
    dmoral: [-15, -5, -1, -1]
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




$ =>
  Tabletop.init(
    key: '1wRFHXvMjvFdvn-hsahXhHDHMofhHDhrpZt4UJ4P21OY',
    simpleSheet: true,
    callback: (data) =>
      for item in data
        window.ActionManager.actions.push new Action(
          id: item['id - какая-нибудь уникальная среди других экшонов строка']
          title: item['title - надпись на кнопке']
          dpain: parseInt item['dpain - изменение унижения']
          dmoral: parseInt item['dmoral - изменение духовности']
          intervalSteps: parseInt item['intervalSteps - через сколько шагов можно применять следующий раз']
          timesLimit: parseInt item['timesLimit - сколько раз можно применять']
          available: true
        )
      ActionManager.render()
      console.log window.ActionManager.actions
    )

  ActionManager.render()

