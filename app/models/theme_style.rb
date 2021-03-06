# == Schema Information
#
# Table name: theme_styles
#
#  id               :integer          not null, primary key
#  name             :string
#  image            :string
#  theme_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  industry         :string
#  example_site_url :string
#

class ThemeStyle < ApplicationRecord

  belongs_to :theme

  validates :name, uniqueness: { scope: :theme_id }

  mount_uploader :image, ImageUploader

  module IndustryCategories
    INDUSTRIES_LIST = ["Art & Photography", "Clothing & Fashion",
                       "Electronics", "Food & Drink",
                       "Health & Beauty", "Home & Garden",
                       "Jewelry & Accessories", "Other",
                       "Responsive", "Sports & Recreation", "Toys & Games" ].freeze
  end

  scope :industry_category, -> (industry_name) do
    unless industry_name.blank?
      where(industry: industry_name) if IndustryCategories::INDUSTRIES_LIST.include?(industry_name)
    end
  end

  scope :themes_price_category, -> (price_category_name) {joins(:theme).merge(Theme.price_category(price_category_name))}

  scope :with_exception_of, -> (style) {self.where.not(id: style.id)}

  def full_theme_style_name
    "#{self.theme.name} #{self.name.downcase}"
  end

  def industry_styles
    ThemeStyle.where(industry: self.industry)
  end
end
