class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :accept]
  before_action :load_question, only: [:create]
  after_action :publish_answer, only: [:create]

  respond_to :js

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      flash_message :success, "Ответ успешно добавлен"
    else
      errors_to_flash @answer
    end
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy!
      flash_message :success, "Ответ успешно удален."
    else
      flash_message :error, "Вы не можете удалять чужие ответы."
    end
  end

  def accept
    if current_user.author_of?(@answer.question)
      @answer.accept!
      flash_message :success, "Ответ успешно принят."
    else
      flash_message :error, "Только автор вопроса может выполнить принятие ответа."
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
