# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  questions_list = $('.questions-list');
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit_question_' + question_id).show();

  $(".vote").bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    $('div#'+vote['object_klass']+vote['object_id']+' > .vote > span.vote-count').html(vote['count']);
  .bind 'ajax:error', (e, xhr, status, error) ->
    $("p.alert").html('');
    $("p.notice").html('');
    errors = $.parseJSON(xhr.responseText);
    $.each errors, (index, value) ->
      $('#flash_messages').append(value);

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'

    received: (data) ->
      questions_list.append(data);
  });