class Address < ActiveRecord::Base
    belongs_to :subscription
    validates :house_number, :street, :city, :postcode, presence: true
end
