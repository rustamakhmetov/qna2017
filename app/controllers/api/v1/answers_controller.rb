class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource(class: (controller_name.classify.constantize rescue nil).present?)

  def index
    @question = Question.find(params[:question_id])
    respond_with @question.answers
  end
end