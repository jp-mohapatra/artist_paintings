class CreatePaintings < ActiveRecord::Migration
  def change
    create_table :paintings do |t|
      t.string :name
      t.attachment :image
      t.belongs_to :user
      t.boolean :is_public
      t.timestamps null: false
    end
  end
end
