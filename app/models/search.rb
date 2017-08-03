class Search
  def self.conditions
    %w{Any Questions Answers Comments Users}
  end

  def self.by_condition(condition, query)
    singular = condition.singularize
    @klass = singular.constantize
    { singular.downcase => @klass.search(query) || [] }
  end
end