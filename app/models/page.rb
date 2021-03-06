# == Schema Information
#
# Table name: pages
#
#  id               :integer          not null, primary key
#  title            :string
#  content          :string
#  shop_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  handle           :string
#  page_title       :string
#  meta_description :string
#  slug             :string
#  publish_on       :datetime
#  published_at     :datetime
#

class Page < ActiveRecord::Base
  extend FriendlyId
  include Concerns::Visibility

  belongs_to  :shop

  friendly_id :handle, use: [:slugged, :scoped], scope: :shop

  validates :title, :shop_id, presence: true
  validates :title, uniqueness: { scope: :shop_id }

end
