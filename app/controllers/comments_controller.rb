class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable
  after_action :publish_comment, only: %i[create]

  respond_to :json

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  private

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :body)
  end

  def load_commentable
    if params.key? :question_id
      @commentable = Question.find(params[:question_id])
    else
      @commentable = Answer.find(params[:answer_id])
    end
  end

  def publish_comment
    return if @comment.errors.any?
    if @commentable.is_a?(Question)
      question_id = @commentable.id
    else
      question_id = @commentable.question.id
    end
    ActionCable.server.broadcast(
        "questions/#{question_id}/comments",
        renderer.render(
            partial: "comments/data",
            locals: { comment: @comment }
        )
    )
  end
end
