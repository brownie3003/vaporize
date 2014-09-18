class SubscriptionChoices < ActiveRecord::Base
    belongs_to :subscription
    belongs_to :eliquid
end
