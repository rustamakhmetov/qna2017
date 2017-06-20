class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :accept]
  before_action :load_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    # if @answer.save
    #   flash_message :success, "Ответ успешно добавлен"
    # else
    #   errors_to_flash @answer
    # end
    respond_to do |format|
      if @answer.save
        format.html { render @answer, layout: false }
      else
        #errors_to_flash @answer
        format.html { render html: @answer.errors.full_messages.join("\n"), status: :unprocessable_entity } #@answer.errors.full_messages.join("\n")
      end
      format.js
    end
  end

  def update
    if @answer.update(answer_params)
      flash_message :success, "Ответ успешно обновлен"
    else
      errors_to_flash @answer
    end
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
end
