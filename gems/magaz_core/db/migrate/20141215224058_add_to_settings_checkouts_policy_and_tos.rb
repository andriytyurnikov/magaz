class AddToSettingsCheckoutsPolicyAndTos < ActiveRecord::Migration
  def change
    add_column :shops, :checkout_refound_policy, :text
    add_column :shops, :checkout_privacy_policy, :text
    add_column :shops, :checkout_term_of_service, :text
  end
end
