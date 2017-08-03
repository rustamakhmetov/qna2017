class Search
  def self.conditions
    %w{Any Questions Answers Comments Users}
  end

  def self.by_condition(condition, query)
    query = ThinkingSphinx::Query.escape(query)
    singular = condition.singularize
    @klasses = [singular.constantize] rescue [Question, Answer, Comment, User]
    @klasses.map {|klass| { klass.to_s.downcase => klass.search(query) || [] }}
  end
end