window.chartFactory = (elId) ->
  new Highcharts.Chart
     chart:
       renderTo: elId
       type: 'line'
     plotOptions:
       line:
         marker:
           enabled: false
     
     title:
       text: ''

     xAxis:
       allowDecimals: false
       minRange: 100
       min: 0
       # minPadding: 2

     yAxis:
       min: -10
       max: 110
       startOnTick: false
       endOnTick: false
       plotLines: [
         {
           color: 'red'
           width: 1
           value: 80
           dashStyle: 'solid'
         }
       ]

     scrollbar:
       enables: true


     series: [
       {
         name: 'Духовность'
         data: []
       }
       {
         name: 'Унижение'
         data: []
       }
     ]
