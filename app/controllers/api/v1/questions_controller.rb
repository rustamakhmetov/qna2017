class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource(class: (controller_name.classify.constantize rescue nil).present?)

  def index
    @questions = Question.all
    respond_with @questions
  end
end