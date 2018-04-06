require 'digest'

class Url < ActiveRecord::Base
  validates :long_url,  presence: true, uniqueness: true, url: true

  before_save :shorten_url

  # Hash long URL into short URL
  def shorten_url
    (5..Digest::SHA256.base64digest(long_url).length).each do |i|
      self.short_url = Digest::SHA256.base64digest(long_url).slice(0..i)
      self.short_url.gsub!(/\//, 'a') if  self.short_url.include?('/')
      break if Url.find_by_short_url(self.short_url).nil?
    end
  end

  def clean
    self.url = self.long_url.strip.gsub(/(https?:\/\/)|(www\.)/, '')
    self.url = "https://#{self.url}"
    self.long_url = url
  end

  def display_url
    if self.long_url.length > 80
      self.long_url.slice(0..79).gsub!(/$/, '...')
    else
      self.long_url
    end
  end
end
