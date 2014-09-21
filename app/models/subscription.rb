class Subscription < ActiveRecord::Base
    has_many :subscription_choices
    has_many :eliquids, through: :subscription_choices
    has_one :address
    belongs_to :subscription_plan

    accepts_nested_attributes_for :address, allow_destroy: true
    accepts_nested_attributes_for :subscription_choices, allow_destroy: true
end
