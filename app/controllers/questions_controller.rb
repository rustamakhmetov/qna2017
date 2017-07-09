class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: [:create]
  before_action :build_answer, only: %i[show]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answer = Answer.new
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    if current_user.author_of?(@question)
      respond_with @question.destroy!
    else
      @question.errors.add(:base, "Вы не можете удалять чужие вопросы.")
      respond_with @question, location: questions_path
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @question.answers.build
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
           partial: "questions/question",
           locals: { question: @question }
        )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
