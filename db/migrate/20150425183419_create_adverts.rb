class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.string :title
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.timestamps null: false
    end
  end
end
