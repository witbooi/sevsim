class window.StoriesView
  constructor: (el) ->
    @el = el
    @carEl = null
    @initCarousel()

  initCarousel: =>
    $ =>
      @carEl = @el.find('.carousel')
      @carEl.slick
        slidesToShow: 4
        slidesToScroll: 1

  addCarouselAction: (actionView) =>
      @carEl.slick "slickAdd", actionView.render()

  render: =>
    for story in StoryManager.stories
      @addCarouselAction story.view

class window.StoryView
  constructor: (story) ->
    @action = story.action
    @el = @getTemplate()
    # @el.find(".content").appendTo "body"

  render: =>
    @el.find(".preview").on "click", () =>
      modalEl = $(".story-content[data-action-id='ritual']")
      modalEl.on "hide.bs.modal", (e) =>
        iframe = modalEl.find("iframe")
        iframe.attr('src', iframe.attr('src')) if iframe.length > 0
      modalEl.modal("show")

    @el

  getTemplate: =>
    tplClassSelector = ".story-template." + @action.id
    tpl = $(tplClassSelector)
    if tpl.length > 0
      tpl = $(tpl[0]).clone()
    else
      tpl = $("<div></div>")

    unless tpl.find(".preview").length > 0
      tpl.append($("<span class='preview'>#{@action.title}</span>"))

    tpl


class window.StoryManager
  @stories =[]
  $ =>
    @view = new StoriesView $("#stories")
    # debugger
    for el in $(".stories-templates .story-content")
      $el = $(el)
      $el.attr("data-action-id", $el.parent(".story-template").attr("data-action-id"))
      $el.appendTo("body")

  @create: (action) =>
    story = new Story action
    @stories.push story
    @view.addCarouselAction story.view
    @view.el.find(".slick-next").click()


class window.Story
  constructor: (action) ->
    @action = action
    @view = new StoryView(@)
