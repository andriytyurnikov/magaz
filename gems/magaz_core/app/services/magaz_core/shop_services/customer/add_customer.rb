class MagazCore::ShopServices::Customer::AddCustomer < ActiveInteraction::Base

  string :first_name, :last_name, :email
  integer :shop_id

  validates :email, presence: true

  validate :customer_uniquness

  def to_model
    MagazCore::Customer.new
  end

  def execute
    customer = MagazCore::Customer.new(inputs)

    unless customer.save
      errors.merge!(customer.errors)
    end

    customer
  end

  private

  def customer_uniquness
    errors.add(:base, I18n.t('default.services.add_customer.customer_exist')) unless customer_unique?
  end

  def customer_unique?
    MagazCore::Customer.where(shop_id: shop_id, email: email).count == 0
  end
end
