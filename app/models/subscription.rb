class Subscription < ActiveRecord::Base
    has_many :eliquids, through: :subscription_choices
    has_one :address
    belongs_to :subscription_plan
end
