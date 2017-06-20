# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit_answer_' + answer_id).show();

  $("form.new_answer").bind 'ajax:success', (e, data, status, xhr) ->
    $('.answers').append(xhr.responseText);
    $('form#new_answer > p > textarea#answer_body').val("");
  .bind 'ajax:error', (e, xhr, status, error) ->
    $("p.alert").html('');
    $("p.notice").html('');
    $('#flash_messages').html(xhr.responseText);