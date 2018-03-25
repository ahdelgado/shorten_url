require 'digest'

class Url < ActiveRecord::Base
    
  VALID_URL_REGEX = /\A((https?):\/\/)?[a-z0-9]+([\-\.]
                      {1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix

  VALID_CHARS = ('a'..'z').to_a + (0..9).to_a + ('A'..'Z').to_a
                      
  validates :url,  presence: true, uniqueness: true,
                    format: { with: VALID_URL_REGEX }

  before_save   :shorten_url

  # Hash long URL into short URL
  def shorten_url
    self.short_url = Digest::SHA256.base64digest(long_url)
  end

  def clean
    self.url = self.long_url.strip.downcase.gsub(/(https?:\/\/)|(www\.)/, '')
    self.url = "http://#{self.url}"
  end

  def display_url
    short_url.slice(0..5)
  end
            
end
