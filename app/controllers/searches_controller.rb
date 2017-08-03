class SearchesController < ApplicationController
  skip_authorization_check

  respond_to :js

  def search
    @query = params[:query]
    @questions = Search.by_condition(params[:condition], @query)
  end
end