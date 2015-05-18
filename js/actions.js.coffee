$ =>
  Tabletop.init
    key: '1wRFHXvMjvFdvn-hsahXhHDHMofhHDhrpZt4UJ4P21OY',
    simpleSheet: true,
    callback: (data) =>
      for item in data
        a = new Action(
          id:            item['id - какая-нибудь уникальная среди других экшонов строка']
          title:         item['title - надпись на кнопке']
          dpain:         eval item['dpain - изменение унижения']
          dmoral:        eval item['dmoral - изменение духовности']
          intervalSteps: eval item['intervalSteps - через сколько шагов можно применять следующий раз']
          timesLimit:    eval item['timesLimit - сколько раз можно применять']
          alive:         !!(eval(item['alive']))
        )
        window.ActionManager.actions.push a

      ActionManager.render()
