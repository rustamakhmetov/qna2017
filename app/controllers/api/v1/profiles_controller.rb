class Api::V1::ProfilesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  authorize_resource :user

  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with User.where.not(id: current_resource_owner.id)
  end
end