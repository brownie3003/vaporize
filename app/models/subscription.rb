class Subscription < ActiveRecord::Base
    after_create :create_stripe_customer
    
    # TODO add validations
    # Can't validate against subscription_choices because view has loads of
    # blank ones, so deal with thos in controller

    validates :first_name, :last_name, :email, :subscription_plan_id, :shipping_day, presence: true

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
                card: stripe_token,
                email: email
        )
        
        self.stripe_customer_id = customer.id

        if initial_ecigarette
            Stripe::InvoiceItem.create(
                customer: customer,
                amount: 2500,
                currency: "gbp",
                description: "E-cigarette kit cost"
            )
        end
        
        customer.subscriptions.create(plan: self.subscription_plan.stripe_plan_id)
        save!
    end
end
