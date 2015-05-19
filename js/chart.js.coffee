window.chartFactory = (elId) ->
  new Highcharts.Chart
     chart:
       renderTo: elId
       type: 'spline'
       animation:
         duration: 940
         easing: "linear"
       backgroundColor: "rgba(255, 255, 255, 0.0)"
     plotOptions:
       spline:
         marker:
           enabled: false
       line:
         marker:
           enabled: false
     
     title:
       text: ''

     tooltip:
       enabled: false

     xAxis:
       allowDecimals: false
       startOnTick: false
       endOnTick: false
       # minRange: 100
       # min: 0
       type: "datetime"
       dateTimeLabelFormats:
         month: '%e. %b'
         year: '%b'
       tickInterval: (3600 * 1000 * 24) * 7
       # minorTickInterval: (3600 * 1000 * 24) * 1
       # minPadding: 2

     yAxis:
       [
         {
           min: -10
           max: 110
           title: ""
           startOnTick: false
           endOnTick: false
           plotLines: [
             {
               color: 'red'
               width: 1
               value: 80
               dashStyle: 'dot'
             }
           ],
           labels:
             format: "{value} %"
         }

       ]

     scrollbar:
       enables: true


     series: [
       {
         name: 'Духовность'
         data: []
         color: "navy"
         shadow:
           color: '#ccc'
           width: 9
           offsetX: 0
           offsetY: 3
       }
       {
         name: 'Унижение'
         data: []
         color: "red"
         shadow:
           color: '#ccc'
           width: 9
           offsetX: 0
           offsetY: 3
       }
     ]



Highcharts.setOptions(
  lang:
    loading: 'Загрузка...',
    months: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'],
    weekdays: ['Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота'],
    shortMonths: ['Янв', 'Фев', 'Март', 'Апр', 'Май', 'Июнь', 'Июль', 'Авг', 'Сент', 'Окт', 'Нояб', 'Дек'],
    exportButtonTitle: "Экспорт",
    printButtonTitle: "Печать",
    rangeSelectorFrom: "С",
    rangeSelectorTo: "По",
    rangeSelectorZoom: "Период",
    downloadPNG: 'Скачать PNG',
    downloadJPEG: 'Скачать JPEG',
    downloadPDF: 'Скачать PDF',
    downloadSVG: 'Скачать SVG',
    printChart: 'Напечатать график'
)
