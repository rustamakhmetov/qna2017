class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :accept]
  before_action :load_question, only: [:create]
  after_action :publish_answer, only: [:create]

  respond_to :js

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    errors_to_flash @answer
    respond_with @answer
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    if current_user.author_of?(@answer)
      respond_with(@answer.destroy!)
    else
      @answer.errors.add(:base, "Вы не можете удалять чужие ответы.")
      respond_with @answer
    end
  end

  def accept
    if current_user.author_of?(@answer.question)
      respond_with(@answer.accept!)
    else
      @answer.errors.add(:base, "Только автор вопроса может выполнить принятие ответа.")
      respond_with @answer
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find_by_id(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body, attachments_attributes: [:file])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
        "questions/#{@question.id}/answers",
        renderer.render(
            partial: "answers/data",
            locals: { answer: @answer }
        )
    )
  end
end
