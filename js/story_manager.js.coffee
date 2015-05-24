class window.StoriesView
  constructor: (el) ->
    @el = el
    @carEl = null
    @initCarousel()

  initCarousel: =>
    $ =>
      @carEl = @el.find('.carousel')
      @carEl.slick
        slidesToShow: 3
        slidesToScroll: 1

  render: =>
    debugger
    for story in StoryManager.stories
      @carEl.slick "slickAdd", story.view.render()


class window.StoryView
  constructor: (story) ->
    @action = story.action
    @el = $("<div class='item'></div>")

  render: =>
    @el.html "<h3>#{@action.title}</h3>"
    @el



class window.StoryManager
  @stories =[]
  $ =>
    @view = new StoriesView $("#stories")

  @create: (action) =>
    story = new Story action
    @stories.push story
    @view.render()
    @view.el.find(".slick-next").click()


class window.Story
  constructor: (action) ->
    @action = action
    @view = new StoryView(@)
