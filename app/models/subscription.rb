class Subscription < ActiveRecord::Base
    after_create :create_stripe_customer
    
    # TODO add validations
    # Can't validate against subscription_choices because view has loads of
    # blank ones, so deal with thos in controller

    validates :first_name, :last_name, :email, :subscription_plan_id,
        :initial_ecigarette, :shipping_day, presence: true

    has_many :subscription_choices
    has_many :eliquids, through: :subscription_choices
    has_one :address
    belongs_to :subscription_plan

    accepts_nested_attributes_for :address, allow_destroy: true
    # :subscription_choices currently not required because not nesting
    # in view: subscriptions/new.html.slim
    # accepts_nested_attributes_for :subscription_choices, allow_destroy: true
    
    def create_stripe_customer
        customer = Stripe::Customer.create(
                :card => stripe_token,
                :plan => 3,
                :email => email
        )
        
        self.stripe_token = customer.id
        save!
    end
end
