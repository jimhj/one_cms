# = require jquery
# = require jquery_ujs
# = require bootstrap/dropdown
# = require bootstrap/button
# = require bootstrap/carousel
# = require jquery.sticky
# = require jquery.lazyload

$(document).ready ->
  $('.nav.navbar').sticky({ topSpacing: 0 }).on 'sticky-start', ->
    $(this).css 'opacity', 0.95
  .on 'sticky-end', ->
    $(this).css 'opacity', 1

  $('.ad-stick').sticky({ topSpacing: 60 })

  $('.navbar-nav > li').mouseenter ->
    $(this).find('.dropdown-menu').show()
  .mouseleave ->
    $(this).find('.dropdown-menu').hide()

  $('i.fa.fa-search').click ->
    $(this).parents('form')[0].submit()

  $('.loadMore').click ->
    $el = $(this)
    page = $el.data 'page'
    next_page = parseInt(page) + 1
    $el.button 'loading'
    $.get '/more', page: next_page, (rsp) ->
      $el.parent().before rsp.html
      $el.data 'page', next_page
      $el.button 'reset'
      $(".lazy-#{next_page}").lazyload(effect : "fadeIn")
    , 'json'

  $('img.lazy-1').lazyload(
    effect : "fadeIn"
  )

  $('img.lazyload').lazyload(
    effect : "fadeIn"
  )

  $('.favorite-btn').click ->
    url = window.location.href
    title = $('title').text()

    if window.external && ('AddFavorite' in window.external)
      window.external.AddFavorite(url, title)
    else if window.sidebar && window.sidebar.addPanel
      window.sidebar.addPanel(title, url, '')
    else
      alert('浏览器不支持, 请手动添加本文章到收藏夹')