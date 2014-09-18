class CreateEliquids < ActiveRecord::Migration
  def change
    create_table :eliquids do |t|
      t.string :name
      t.string :volume

      t.timestamps
    end
  end
end
