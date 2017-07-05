$ ->
  $(".question-comments").bind 'ajax:success', (e, data, status, xhr) ->
    comment = $.parseJSON(xhr.responseText)
    $('.question-comments > .comments').append(comment['body_html'])
    $('form#new_comment > * > textarea#comment_body').val('')
