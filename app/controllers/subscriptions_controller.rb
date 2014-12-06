class SubscriptionsController < ApplicationController
	before_action :logged_in_subscription, only: [:show, :edit, :update, :destroy]
	before_action :correct_subscription, only: [:show, :edit, :update, :destroy]

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
		
		# Set stripe token
		# NB stripe_token is 1 time use only, maybe shouldn't save, should check if it's still in params on model file.
		@subscription.stripe_token = params[:stripeToken]

		if @subscription.save
			# Need to save the subscription before creating subscription choices, same with updating it.
			add_subscription_choices
			log_in @subscription
			flash[:success] = "Welcome to Luxate!"
			redirect_to @subscription
		else
			@eliquids = Eliquid.all
			@subscription_plans = SubscriptionPlan.all
			render 'new'
		end
	end

	def edit
		@subscription = Subscription.find(params[:id])
		@eliquids = Eliquid.all
		@subscription_plans = SubscriptionPlan.all
	end
	
	def update
		@subscription = Subscription.find(params[:id])

		if @subscription.update_attributes(subscription_params)
			@subscription.subscription_choices.destroy_all
			add_subscription_choices
			flash[:success] = "Subscription updated"
			redirect_to @subscription
		else
			@eliquids = Eliquid.all
			@subscription_plans = SubscriptionPlan.all
			render 'edit'
		end
	end
	
	def destroy
		Subscription.find(params[:id]).destroy
		flash[:success] = "Sorry to see you go."
		redirect_to root_path
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

		# Iterate over the eliquids array and build a choice for each item
		# A good refactor would be to get rails to do the SQL itself using
		# form_for correctly in the view.
		def add_subscription_choices
			params[:subscription_choices].each do |eliquid_id|
				@subscription.subscription_choices.create(eliquid_id: eliquid_id)
			end
		end

		def logged_in_subscription
			unless logged_in?
				flash[:danger] = "Please log in."
				redirect_to login_url
			end
		end

		def correct_subscription
			@subscription = Subscription.find(params[:id])
			redirect_to(root_url) unless @subscription == current_subscription
		end
	
end
