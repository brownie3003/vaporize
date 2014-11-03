class AddStripePlanIdToSubscriptionPlan < ActiveRecord::Migration
  def change
    add_column :subscription_plans, :stripe_plan_id, :integer
  end
end
