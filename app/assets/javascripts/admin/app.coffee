# = require jquery
# = require jquery_ujs
# = require twbs-admin/bootstrap.min
# = require twbs-admin/sb-admin-2
# = require twbs-admin/menu
# = require redactor-rails
# = require redactor-rails/config
# = require bootstrap-select

$(document).ready ->
  $('.selectpicker').selectpicker()
  $('[data-toggle="tooltip"]').tooltip()

  $('.node-tree').click ->
    $t = $(this)
    $tr = $t.parents('tr')
    node_id = $tr.data 'node_id'
    parent_id = $tr.data 'parent'

    $t.toggleClass('contract').toggleClass('explode')
    $("tr[data-parent=#{node_id}]").toggleClass('hide');