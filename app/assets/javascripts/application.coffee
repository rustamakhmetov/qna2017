# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
# vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require jquery.remotipart
#= require turbolinks
#= require cocoon
#= require action_cable
#= require toastr
#= require_tree .

App = App || {};
App.cable = ActionCable.createConsumer();

toastr.options.closeButton = true;

$(document).bind 'ajax:success', (e, data, status, xhr) ->
  show_flash_messages(xhr)
.bind 'ajax:error', (e, xhr, status, error) ->
  show_flash_messages(xhr)

root = exports ? this

root.show_flash_messages = (xhr) ->
  try
    datas = $.parseJSON(xhr.responseText)
    if datas.messages?
      list_messages = datas.messages
    else
      list_messages = datas
    for message_type, messages of list_messages
      switch message_type
        when "success" then toastr.success('', mes) for mes in messages
        when "error" then toastr.error('', mes) for mes in messages
        when "errors"
          for field, errors of messages
            for error in errors
              toastr.error('', field.ucfirst()+' '+error)
        else null

String.prototype.ucfirst = ->
  @split('').map((char, i) -> unless i then char.toUpperCase() else char).join('')