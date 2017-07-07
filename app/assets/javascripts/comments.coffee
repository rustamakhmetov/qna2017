$ ->
  $(".comments").bind 'ajax:success', (e, data, status, xhr) ->
    data_obj = $.parseJSON(xhr.responseText)
    publish_comment(data_obj, false)
    $(comment_div(data_obj) + ' form#new_comment textarea#comment_body').val('')

  $(document).ready ->
    App.cable.subscriptions.create({
      channel: 'CommentsChannel',
      questionId: question_id
    }, {
      received: (data) ->
        data_obj = $.parseJSON(data)
        publish_comment(data_obj, true)
    });

root = exports ? this

root.publish_comment = (data, verify) ->
  return unless data?
  is_publish = true
  if verify
    user_data = $('a#logout').data()
    if user_data and data.user_id==user_data.userId
      is_publish = false
  if is_publish
    $(comment_div(data) + ' div.list-comments').append(data.body_html)

root.comment_div = (data) ->
  object_klass = data.commentable_type.toLowerCase()
  object_id = data.commentable_id
  return 'div#' + object_klass + object_id
