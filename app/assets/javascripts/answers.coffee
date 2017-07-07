# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit_answer_' + answer_id).show();

  root = exports ? this

  $(document).ready ->
    App.cable.subscriptions.create({
      channel: 'AnswersChannel',
      questionId: question_id
    }, {
      received: (data) ->
        data_obj = $.parseJSON(data)
        user_data = $('a#logout').data()
        if !user_data or (user_data and data_obj.user_id!=user_data.userId)
          $('.answers').append(data_obj.body_html);
    });