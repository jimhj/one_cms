# = require jquery
# = require jquery_ujs
# = require bootstrap-sprockets
# = require jquery.sticky

$(document).ready ->
  $('.nav.navbar').sticky({ topSpacing: 0 }).on 'sticky-start', ->
    $(this).css 'opacity', 0.95
  .on 'sticky-end', ->
    $(this).css 'opacity', 1

  $('.navbar-nav > li').mouseenter ->
    $(this).find('.dropdown-menu').show()
  .mouseleave ->
    $(this).find('.dropdown-menu').hide()

  $('i.fa.fa-search').click ->
    $(this).parents('form')[0].submit()

  $('.favorite-btn').click ->
    url = window.location.href
    title = $('title').text()

    if window.external && ('AddFavorite' in window.external)
      window.external.AddFavorite(url, title)
    else if window.sidebar && window.sidebar.addPanel
      window.sidebar.addPanel(title, url, '')
    else
      alert('浏览器不支持, 请手动添加本文章到收藏夹')