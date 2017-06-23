# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit_answer_' + answer_id).show();

  $(".vote").bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    $('div#'+vote['object_klass']+vote['object_id']+' > .vote > span.vote-count').html(vote['count']);
  .bind 'ajax:error', (e, xhr, status, error) ->
    $("p.alert").html('');
    $("p.notice").html('');
    errors = $.parseJSON(xhr.responseText);
    $.each errors, (index, value) ->
      $('#flash_messages').append(value);