class CalculateReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    if object.user
      reputation = Reputation.calculate(object)
      object.user.update(reputation: reputation)
    end
  end
end
