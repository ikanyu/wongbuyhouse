class AddTableToSeriMaya < ActiveRecord::Migration
  def change
  	create_table :serimayas do |t|
  		t.string :name
  		t.date :date
  		t.integer :size
  		t.integer :price
  		t.string :link
  		t.string :bed
  		t.string :furnish

  		t.timestamps
  	end
  end
end
