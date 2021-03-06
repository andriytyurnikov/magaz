# == Schema Information
#
# Table name: checkouts
#
#  id                 :integer          not null, primary key
#  note               :text
#  status             :string
#  financial_status   :string
#  fulfillment_status :string
#  currency           :string
#  email              :string
#  created_at         :datetime
#  updated_at         :datetime
#  customer_id        :integer
#


class Checkout < ActiveRecord::Base
  STATUSES = %w[open cancelled]
  # FINANCIAL_STATUSES = %w[authorized
  #                         paid pending partially_paid
  #                         partially_refunded refunded unpaid voided]
  # FULFILLMENT_STATUSES = %w[fulfilled
  #                           not_fulfilled
  #                           partially_fulfilled
  #                           unfulfilled ]

  belongs_to  :customer
  has_many    :line_items

  scope :orders, -> { where(status: STATUSES) }
  scope :not_orders, -> { where(status: nil) }
  scope :abandoned_checkouts, -> { where("checkouts.email IS NOT NULL") }

  include Concerns::ShoppingCart
  validates :status, presence: true, if: ->(u) { u.status.in?(STATUSES) || u.status_was.in?(STATUSES) }
  validates :email, format: { with: Concerns::PasswordAuthenticable::EMAIL_VALID_REGEX }, allow_blank: true
end
