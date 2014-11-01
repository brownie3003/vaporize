class AddBottleCountDescriptionAndEquivalentMonthlyCigarettesDescriptionToSubscriptionPlans < ActiveRecord::Migration
  def change
    add_column :subscription_plans, :bottle_count_description, :string
    add_column :subscription_plans, :equivalent_cigarettes_description, :string
  end
end
