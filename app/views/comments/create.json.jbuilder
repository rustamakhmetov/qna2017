json.(@comment, :id, :commentable_id, :commentable_type, :body)
json.body_html ApplicationController.render(
    partial: "comments/comment",
    locals: { comment: @comment }
)
json.messages flash.to_h