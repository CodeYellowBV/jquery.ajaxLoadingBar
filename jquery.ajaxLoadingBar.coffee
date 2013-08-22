(($) ->
  $.fn.ajaxLoadingBar = (options)->
    settings = $.extend(
      turbolinks: true
      ajax: true
    , options)

    if settings.turbolinks
      $(document).on 'page:fetch', ->
        window.pageLoader.startLoader()

      $(document).on 'page:receive', ->
        window.pageLoader.sliderWidth = $('#pageLoader').width()

      $(document).on 'page:load', ->
        window.pageLoader.restoreLoader()

      $(document).on 'page:restore', ->
        $('#pageLoader').remove()
        window.pageLoader.restoreLoader()

    if settings.ajax
      window.remoteStack = []
      $(document).on 'mouseup', '*[data-no-loader="true"]', ->
        window.remoteStack.push($(this)) 

      $(document).ajaxComplete (e)->
        unless $('#pageLoader').length == 0
          $('#pageLoader').remove()
          window.pageLoader.restoreLoader()
        else
          $('#pageLoader').remove()

      $(document).ajaxStart (e)->
        unless window.remoteStack.pop()
          window.pageLoader.startLoader()

    window.pageLoader = 
      sliderWidth: 0
      startLoader: () ->
        $('#pageLoader').remove()

        $('<div/>', {
          id: 'pageLoader'
        }).appendTo('body').animate({width: $(document).width() * .4}, 
        2000).animate({width: $(document).width() * .6}, 
        6000).animate({width: $(document).width() * .90}, 
        10000).animate({width: $(document).width() * .99}, 
        20000)

      restoreLoader: () ->
        $('<div/>', {
          id: 'pageLoader',
        }).css({width: window.pageLoader.sliderWidth}).appendTo('body').animate({width: $(document).width()}, 500).fadeOut () ->
          $(this).remove()
) jQuery