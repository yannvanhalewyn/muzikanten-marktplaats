$(document).on "ready page:load", ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      next_page_url = $('.pagination .next_page a').attr('href')
      if next_page_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="loading..." title="loading..." />')
        $.getScript next_page_url

