require 'nokogiri'
require 'httparty'

module Instructions
  def introductions
    puts 'Welcome to dev.to webscraper. This CLI tool gathered articles based on the hashtag provides'
    puts 'If you want to quit, simple type (q) the next time you are prompted to enter a value'
    puts 'Please provide a hashtag to continue..'
    puts ''
  end

  def quit_message
    puts 'You have quit the scraper'
  end

  def invalid_entry
    puts 'Your entry is invalid, try again'
  end
end

class Scraper
  extend Instructions

  def self.input
    user_input = gets.chomp
    get_hashtag(user_input)
  end

  def self.get_hashtag(user_input)
    if user_input == 'q'
      quit_message
    elsif user_input.empty?
      invalid_entry
      get_input
    else
      scrape_data(user_input.to_s)
    end
  end

  def self.scrape_data(hashtag)
    url = "https://dev.to/t/#{hashtag}"
    puts 'getting data ...'
    html = HTTParty.get(url)
    response = Nokogiri::HTML(html)
    info = []
    articles = response.css('.crayons-article__header__meta')
    if articles.empty?
      puts "No article for for hashtag: #{hashtag}"
    else
      articles.do |section|
        title_and_author = section.search('h1.fs-3xl s:fs-4xl l:fs-5xl fw-bold s:fw-heavy lh-tight', 'a.crayons-link')
      info.push({
                  title: title_and_author[0].text.gsub(/\n/, '').strip.gsub(/\s+/, ' '),
                  author: title_and_author[1].text.gsub(/\n/, '').strip.gsub(/\s+/, ' ')
                })
    end
    puts info
    get_input
  end
end

Scraper.introductions
Scraper.get_input
