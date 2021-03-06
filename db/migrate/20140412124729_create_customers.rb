class CreateCustomers < ActiveRecord::Migration[4.2]
  def change
    create_table :customers do |t|
      t.boolean :accepts_marketing
      t.string :email
      t.string :first_name
      t.string :last_name
      t.references :shop
    end
  end
end
