class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  alias_attribute :current_user, :current_resource_owner

  respond_to :json

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token&.resource_owner_id
  end
end