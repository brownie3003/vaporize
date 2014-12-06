require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
	def setup
		@address = Address.new
		@subscription = Subscription.new(shipping_day: 1,
		                                 email: "user@example.com",
		                                 first_name: "Testy",
		                                 last_name: "Test",
		                                 initial_ecigarette: true,
		                                 subscription_plan_id: 1,
		                                 address: @address
		)
	end
	
	test "duplicate email is not permitted" do
		duplicate_user = @subscription.dup
		duplicate_user.email = @subscription.email.upcase
		@subscription.save
		assert_not duplicate_user.valid?
	end
end
