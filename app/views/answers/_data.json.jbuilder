json.body_html renderer.render(
    partial: "answers/answer",
    locals: { answer: answer }
)
json.user_id current_user.id