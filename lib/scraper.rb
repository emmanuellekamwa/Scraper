require 'nokogiri'
require 'httparty'
require 'open-uri'

class Scraper
  attr_accessor :@parse_page
  def initialize
    doc = HTTParty.get('http://store.nike.com/us/en_us/pw/mens-nikeid-lifestyle-shoes/1k9Z7puZoneZoi3')
    @parse_page ||= nokogiri::HTML(doc)
  end

  def names
    item_container.css('.product-card-title').css('div').children.map(&:text).compact
  end

  def prices
    item_container.css('.product-price').css('div').children.map(&:text).compact
  end

  private

  def item_container
    parse_page.css('.product-grid-info')
  end

  scraper = Scraper.new
  names = scraper.get_names
  prices = scraper.get_prices

  (0...prices.size).each do |index|
    puts "--- index: #{index + 1} ---"
    puts "Name: #{names[index]} | price: #{prices[index]}"
  end
end
