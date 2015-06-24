preloadImages = (imageArray, index) ->
  index = index or 0
  if imageArray and imageArray.length > index
    img = new Image

    img.onload = ->
      preloadImages imageArray, index + 1
      return

    img.src = imageArray[index]
  return

preloadImages [
  'img/face/0.png',
  'img/face/10.png',
  'img/face/20.png',
  'img/face/30.png',
  'img/face/40.png',
  'img/face/50.png',
  'img/face/60.png',
  'img/face/70.png',
  'img/face/80.png',
  'img/face/90.png',
  'img/face/100.gif',
  'img/face/dead.png',
  'img/face/fled.png',
]

