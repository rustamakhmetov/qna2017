module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    @votable.votes.create(user: current_user) unless current_user&.author_of?(@votable)
    respond_to do |format|
      format.json { render json: {object_klass: @votable.class.name.downcase, object_id: @votable.id, count: @votable.votes.count}.to_json }
    end
  end

  def vote_down
    @votable.votes.first.destroy! if @votable.votes.count>0 && !current_user&.author_of?(@votable)
    respond_to do |format|
      format.json { render json: {object_klass: @votable.class.name.downcase, object_id: @votable.id, count: @votable.votes.count}.to_json }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end