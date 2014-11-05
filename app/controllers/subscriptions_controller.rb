class SubscriptionsController < ApplicationController
	
	before

	def show
		@subscription = Subscription.find(params[:id])
	end

	def new
		@subscription = Subscription.new
		@eliquids = Eliquid.all
		@subscription_plans = SubscriptionPlan.all
	end

	def create
		# Assign all the params coming from the view
		@subscription = Subscription.new(subscription_params)

		# Iterate over the eliquids array and build a choice for each item
		# A good refactor would be to get rails to do the SQL itself using
		# form_for correctly in the view.
		params[:subscription_choices].each do |eliquid_id|
			# Deal with all blank flavour selects
			if eliquid_id != ""
				@subscription.subscription_choices.build(eliquid_id: eliquid_id)
			end
		end
		
		# Set stripe token
		# NB stripe_token is 1 time use only, maybe shouldn't save, should check if it's still in params on model file.
		@subscription.stripe_token = params[:stripeToken]

		if @subscription.save
			redirect_to @subscription
		else
			@eliquids = Eliquid.all
			@subscription_plans = SubscriptionPlan.all
			render 'new'
		end
	end

	def edit
	end

	private
		def subscription_params
			params.require(:subscription).permit(
				:first_name,
				:last_name,
				:email,
				:subscription_plan_id,
				:shipping_day,
				:initial_ecigarette,
				address_attributes: [
					:house_number,
					:street,
					:second_line,
					:city,
					:county,
					:postcode
				]
			)
		end
end
