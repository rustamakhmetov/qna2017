class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))
    if @comment.save
      flash_message :success, "Комментарий успешно добавлен"
    else
      errors_to_flash @comment
    end
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
end
