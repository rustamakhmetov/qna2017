class SearchesController < ApplicationController
  skip_authorization_check

  respond_to :js

  def search
    @query = params[:query]
    @results = Search.by_condition(params[:condition], @query)
  end
end