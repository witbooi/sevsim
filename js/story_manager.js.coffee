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

  @bgColors: ["#f9d590", "#f9b489", "#b2ffd4", "#8effc5", "#e7f492", "#f1ffa5", "#ffc482", "#f9acb6", "#ef9bce", "#edf77e", "#95f9bc", "#f28b79", "#fca4d6", "#fcddc2", "#9af4c1", "#d0f489", "#bdf7f9", "#f2809a", "#f7b98a", "#e7ffa8", "#f9e57c", "#f2bdf9", "#a7eef2", "#c9f975", "#95f9d3", "#90f4ba", "#8afc9f", "#c4ceff", "#f7e891", "#eef497", "#8bf4b0", "#f29d6f", "#f7a0bd", "#ddf28c", "#f9f9a2", "#d6fc76", "#ccffa8", "#a9fcce", "#cfef8b", "#a5ddf7", "#dca1fc", "#eaf977", "#ccf9ff", "#c4f276", "#fcd3c4", "#f7ea94", "#bfedfc", "#fcceb3", "#f4e57f", "#f7e3a3", "#fcc4e9", "#ffeead", "#f9e39a", "#f2d2a2", "#f9bbd5", "#b8f799", "#d3ff8c", "#fcccba", "#ffa59b", "#cff48d", "#f2a796", "#a5ffdb", "#c3ffa8", "#f1ff87", "#e2c7fc", "#fce5bf", "#aedffc", "#e6f984", "#ffa6a3", "#ffed93", "#ffc375", "#e8ffaf", "#e0bdfc", "#f7cc94", "#ffc4d3", "#fce4c2", "#f7ffaf", "#c8ffaf", "#ffd2c9", "#f4b2e3", "#ffc5aa", "#b2ffdc", "#e6ffa8", "#d2ffad", "#fcb8bf", "#fcef9f", "#fffcbf", "#c5f282", "#cefca9", "#f9ed90", "#ff96d5", "#fc8fdd", "#fffbbf", "#dcc4fc", "#acdaf9", "#efd98f", "#d2c1ff", "#fcfa88"]


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
