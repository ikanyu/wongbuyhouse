class AddLinkToSeriMaya < ActiveRecord::Migration
  def change
  	add_column :serimayas, :image_link, :string
  	add_column :prima16s, :image_link, :string
  end
end
