class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:edit, :update, :destroy]
  before_action :load_question, only: [:create]

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to @question, notice: "Ответ успешно добавлен"
    else
      flash_message :notice, @answer.errors.full_messages.join("<br>")
      render 'questions/show'
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit, notice: @answer.errors.full_messages.join("<br>")
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question_id), notice: "Ответ успешно удален."
    else
      redirect_to question_path(@answer.question_id), notice: "Вы не можете удалять чужие ответы."
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
    params.require(:answer).permit(:question_id, :body)
  end
end
