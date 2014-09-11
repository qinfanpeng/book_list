class Pagination
  constructor: (@container_selector, @resources, @per_page, @current_page_number=1)->


  paging: ->
    @generate_pagination_link()
    @bind_event_listener()
    @show_current_page_resources()

  generate_pagination_link: ->
    @generate_previous_page_buttion()
    @generate_page_numbers()
    @generate_next_page_buttion()
    @refresh_pagination_link()

  bind_event_listener: ->
    @previous_page_button().on("click", @previous_page)
    @next_page_button().on("click", @next_page)
    $(".page_number").on("click", @go_to)

    $(".previous_page, .page_number, .next_page").on("click", =>
      @refresh_pagination_link()
      @show_current_page_resources()
    )


  page_count: ->
    Math.ceil(@resources.length / @per_page)

  next_page: =>
    @current_page_number += 1

  go_to: (event)=>
    page_number = parseInt($(event.target).text())
    @current_page_number = page_number

  previous_page: =>
    @current_page_number -= 1

  is_first_page: ->
    @current_page_number is 1

  is_last_page: ->
    @current_page_number is @page_count();

  generate_previous_page_buttion: ->
    @container().append "<a href='#' class='previous_page'>上一页</a>"

  generate_next_page_buttion: ->
    @container().append "<a href='#' class='next_page'>下一页</a>"

  generate_page_numbers: ->
    for page_number in [1..@page_count()]
      if page_number is @current_page_number
        @container().append "<a href='#' class='page_number current_page'>#{page_number}</a>"
      else
        @container().append "<a href='#' class='page_number'>#{page_number}</a>"

  container: ->
    $(@container_selector)

  refresh_pagination_link: =>
    @move_current_page_class_to_current_link()
    @refresh_visibility_of_previous_page_button()    
    @refresh_visibility_of_next_page_button()

  refresh_visibility_of_previous_page_button: ->
    return @previous_page_button().hide() if @is_first_page()
    @previous_page_button().show()
  
  refresh_visibility_of_next_page_button: ->
    return @next_page_button().hide() if @is_last_page()
    @next_page_button().show()

  move_current_page_class_to_current_link: ->
    $(".page_number").removeClass("current_page")
    pagination = this
    $(".page_number").each ->
      page_number =  parseInt($(this).text())
      $(this).addClass("current_page") if page_number is pagination.current_page_number

  previous_page_button: ->
    $(".previous_page")

  next_page_button: ->
    $(".next_page")

  show_current_page_resources: =>
    $(".item").hide(100)

    start_postion = (@current_page_number - 1) * @per_page
    end_postion = @current_page_number * @per_page

    for postion in [start_postion...end_postion]
      $("#item_#{postion}").show(1000)


window.Pagination = Pagination








