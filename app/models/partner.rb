# == Schema Information
#
# Table name: partners
#
#  id          :integer          not null, primary key
#  name        :string
#  website_url :string
#  created_at  :datetime
#  updated_at  :datetime
#

class Partner < ApplicationRecord

  has_many :themes, dependent: :destroy
  has_many :theme_styles, through: :themes

  validates :name, presence: true
  validates :website_url, presence: true,
            format: { with: /(https?:\/\/(?:www\.|(?!www))[^\s\.]+\.[^\s]{2,}|www\.[^\s]+\.[^\s]{2,})/ }

  validates :name, :website_url, uniqueness: true
end
