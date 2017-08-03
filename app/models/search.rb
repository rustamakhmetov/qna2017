class Search
  def self.conditions
    %w{Any Questions Answer Comments Users}
  end

  def self.by_condition(condition, query)
    @klass = condition.singularize.constantize
    @klass.search(query) || []
  end
end