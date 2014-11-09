module SessionsHelper
	def log_in(subscription)
		session[:subscription_id] = subscription.id
	end
	
	def current_subscription
		@current_subscription ||= Subscription.find_by(id: session[:subscription_id])
	end
	
	def logged_in?
		!current_subscription.nil?
	end
	
	def log_out
		session.delete(:subscription_id)
		@current_subscription = nil
	end
end
