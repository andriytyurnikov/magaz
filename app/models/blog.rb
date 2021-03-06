# == Schema Information
#
# Table name: blogs
#
#  id               :integer          not null, primary key
#  title            :string
#  shop_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  handle           :string
#  page_title       :string
#  meta_description :string
#  slug             :string
#

class Blog < ActiveRecord::Base
  extend FriendlyId

  has_many    :articles
  has_many    :comments, through: :articles
  belongs_to  :shop

  friendly_id :handle, use: [:slugged, :scoped], scope: :shop
  validates :title, :shop_id, presence: true
  validates :title, uniqueness: { scope: :shop_id }

end
