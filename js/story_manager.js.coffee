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

  addCarouselAction: (actionView) =>
      @carEl.slick "slickAdd", actionView.render()

  render: =>
    for story in StoryManager.stories
      @addCarouselAction story.view

class window.StoryView
  constructor: (story) ->
    console.log("New story")
    @action = story.action
    @el = $("<div></div>")

  render: =>
    if $(".story-template." + @action.id).length > 0
      content = $(".story-template." + @action.id).html()
      $(".story-template." + @action.id).remove()
    else
      content = "<span>#{@action.title}</span>"

    window.x = @el

    @el.html content
    @el.find(".content").appendTo "body"

    @el.find(".preview").on "click", () =>
      @el.find(".content").modal("toggle")

    @el



class window.StoryManager
  @stories =[]
  $ =>
    @view = new StoriesView $("#stories")

  @create: (action) =>
    story = new Story action
    @stories.push story
    @view.addCarouselAction story.view
    @view.el.find(".slick-next").click()


class window.Story
  constructor: (action) ->
    @action = action
    @view = new StoryView(@)
