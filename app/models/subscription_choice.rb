class SubscriptionChoice < ActiveRecord::Base
    belongs_to :subscription
    belongs_to :eliquid
    accepts_nested_attributes_for :eliquid
end