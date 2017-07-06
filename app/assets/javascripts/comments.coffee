$ ->
  $(".comments").bind 'ajax:success', (e, data, status, xhr) ->
    comment = $.parseJSON(xhr.responseText)
    object_klass = comment.commentable_type.toLowerCase()
    object_id = comment.commentable_id
    object_div = 'div#' + object_klass + object_id
    $(object_div + ' div.list-comments').append(comment['body_html'])
    $(object_div + ' form#new_comment textarea#comment_body').val('')
