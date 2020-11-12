require 'httparty'
require 'nokogiri'

class Scraper
  attr_reader :parse_page
  def initialize
    url = 'https://www.nike.com/w/new-3n82y'
    doc = HTTParty.get(url).body
    @parse_page ||= Nokogiri::HTML(doc)
  end

  def names
    item_container.css('.product-card__title').children.map(&:text).compact
  end

  def prices
    item_container.css('.product-price').children.map(&:text).compact
  end

  private

  def item_container
    @parse_page.css('.product-grid')
  end
end
