class AddTableToPrima16 < ActiveRecord::Migration
  def change
  	create_table :prima16s do |t|
  		t.string :name
  		t.date :date
  		t.integer :size
  		t.integer :price
  		t.string :link
  		t.integer :bed
  		t.string :furnish

  		t.timestamps
  	end
  end
end
