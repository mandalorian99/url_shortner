require 'open-uri'

class ShortUrl < ApplicationRecord
  include Generatable

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  scope :top_urls, ->(limit: 100) { order("click_count DESC").limit(100).select_excluded }
  scope :select_excluded, -> {select(ShortUrl.attribute_names - ['created_at', 'updated_at'] )}
  
  validate :validate_full_url
  
  before_save do
    self.shortcode = self.gen_short_code if self.shortcode.blank?
  end

  after_save do
    UpdateTitleJob.perform_later(shortcode) if shortcode.nil?
  end

  def short_code
    shortcode
  end

  def update_title!
    URI.open(full_url) do |page|
      dom = Nokogiri::HTML(page)
      page_title = dom.at_css('title').text
      update(title: page_title)
    end
  end

  def incr_click_count
    increment(:click_count)
    save!
  end

  def public_attributes
    attributes.except('created_at', 'updated_at')
  end

  private

  def validate_full_url
    uri = URI::parse(full_url) rescue nil
    if full_url.nil?
      errors[:full_url] << "can't be blank"
    end

    unless uri.kind_of?(URI::HTTP)
      errors[:full_url] << "is not a valid url"
    end
  end

end
