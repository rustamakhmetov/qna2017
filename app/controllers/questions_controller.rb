class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :vote]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))
    if @question.save
      redirect_to @question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy!
      message = "Вопрос успешно удален."
    else
      message = "Вы не можете удалять чужие вопросы."
    end
    redirect_to questions_path, notice: message
  end

  def vote
    respond_to do |format|
      act = params[:act].to_sym
      if [:up, :down].include?(act)
        @question.votes.create(user: current_user) if act==:up
        @question.votes.first.destroy! if act==:down && @question.votes.count>0
        format.json { render json: {object_klass: "question", object_id: @question.id, count: @question.votes.count}.to_json }
      else
        format.json { render json: ["unknow act"].to_json, status: :unprocessable_entity }
      end
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
