class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: [:create]

  authorize_resource

  respond_to :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answer = Answer.new
    @subscription = (current_user.subscription_of(@question) if current_user) || Subscription.new
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
    respond_to do |format|
      format.html do
        if @question.errors.empty?
          redirect_to(question_path(@question))
        else
          render :edit
        end
      end
    end
  end

  def destroy
    respond_with @question.destroy!
  end

  private

  def load_question
    @question = Question.find(params[:id])
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
