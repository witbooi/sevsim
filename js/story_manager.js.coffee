class window.StoriesView
  constructor: (el) ->
    @el = el
    @carEl = null
    @initCarousel()

  initCarousel: =>
    $ =>
      @carEl = @el.find('.carousel')
      @carEl.slick
        slidesToShow: 5
        slidesToScroll: 1
        infinite: false

  addCarouselAction: (actionView) =>
      @carEl.slick "slickAdd", actionView.render()

  render: =>
    for story in StoryManager.stories
      @addCarouselAction story.view

class window.StoryView
  constructor: (story) ->
    @action = story.action
    @el = @getTemplate()

  render: =>
    @el.find(".preview").on "click", () =>
      modalEl = $(".story-content[data-action-id='" + @action.id + "']")
      modalEl.off "hide.bs.modal"
      modalEl.on "hide.bs.modal", (e) =>
        iframe = modalEl.find("iframe")
        iframe.attr('src', iframe.attr('src')) if iframe.length > 0
        app.start()
      if modalEl.length > 0
        modalEl.modal("show")
        app.suspend()

    @el

  getTemplate: =>
    tplClassSelector = ".story-template." + @action.id
    tpl = $(tplClassSelector)

    if tpl.length > 0
      tpl = $(tpl[0]).clone()
    else
      tpl = $("<div></div>")

    unless tpl.find(".preview").length > 0
      cnt = if (tpl.find(".modal-body").length > 0)
        "<a>#{@action.title}</a>"
      else
        @action.title

      tpl.append($("<span class='preview'>#{cnt}</span>"))

    tpl.find(".preview > a").attr("href", "#").attr("onclick", "return false;")

    tpl.css("background-color", _.sample(StoryView.bgColors))
    tpl

  @bgColors: randomColor({luminosity: 'light', count: 30})


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
    @view.carEl.slick("slickNext")


class window.Story
  constructor: (action) ->
    @action = action
    @view = new StoryView(@)
