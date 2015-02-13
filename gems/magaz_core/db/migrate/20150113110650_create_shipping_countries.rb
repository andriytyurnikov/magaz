class CreateShippingCountries < ActiveRecord::Migration
  def change
    create_table :shipping_countries do |t|
      t.string :name
      t.string :tax

      t.belongs_to :shop
      t.belongs_to :country
    end
  end
end
