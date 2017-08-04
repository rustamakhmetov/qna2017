class Search
  CONDITIONS = %w{Any Questions Answers Comments Users}

  def self.by_condition(condition, query)
    query = ThinkingSphinx::Query.escape(query)
    if CONDITIONS.include?(condition) && condition!="Any"
      singular = condition.singularize
      @klasses = [singular.constantize]
    else
      @klasses = [Question, Answer, Comment, User]
    end
    ThinkingSphinx.search query, :classes => @klasses
  end
end