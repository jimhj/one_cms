# = require jquery
# = require jquery_ujs
# = require bootstrap-sprockets

$(document).ready ->
  $('.navbar-nav > li').mouseenter ->
    $(this).find('.dropdown-menu').show()
  .mouseleave ->
    $(this).find('.dropdown-menu').hide()