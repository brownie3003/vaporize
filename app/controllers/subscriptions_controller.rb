class SubscriptionsController < ApplicationController

	def new
		@subscription = Subscription.new
		@subscription.subscription_plan = SubscriptionPlan.find_by(interval_cost: session[:subscription_plan])
		@subscription.initial_ecigarette = session[:ecigarette]
		puts session[:eliquids]
	end

	def create
		puts session[:eliquids]
		@subscription = Subscription.new(subscription_params)
        session[:eliquids].each do |flavour|
            @subscription.subscription_choices.build(eliquid: Eliquid.find_by(flavour: flavour))
        end
	    @subscription.subscription_plan = SubscriptionPlan.find_by(interval_cost: session[:subscription_plan])
        if @subscription.save
            redirect @subscription
		else
			puts "NAY"
			render 'new'
		end
	end

	def edit
    end

    def newPlan
	    # Store object into session, don't know how to return 500 or redirect to subscriptions/new shit head
		if request.xhr?
			session[:eliquids] = params[:subscription][:flavours]
			session[:subscription_plan] = params[:subscription][:price]
			session[:ecigarette] = params[:cigarette]
			format.json { head :ok }
		end
    end

	private
		def subscription_params
			params.require(:subscription).permit(
				:first_name,
				:last_name,
				:email,
				:subscription_plan_id,
				:shipping_day,
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
