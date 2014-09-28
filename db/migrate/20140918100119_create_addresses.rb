class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :house_number
      t.string :street
      t.string :second_line
      t.string :city
      t.string :county
      t.string :postcode

      t.timestamps
    end
  end
end
