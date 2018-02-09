require "base64"

class Url < ActiveRecord::Base
    
  VALID_URL_REGEX = /\A((http|https):\/\/)?[a-z0-9]+([\-\.]
                      {1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
                      
  validates :long_url,  presence: true, uniqueness: true,
                    format: { with: VALID_URL_REGEX }
                                          
  
  # Hash long URL into short URL
  def self.generate(long_url)
    url = Url.where(long_url: long_url).create
    url.short_url = self.shorten_url
    url
  end

  def self.clean(short_url)
      short_url = 'http://' << short_url.split("").shuffle.join
      short_url
  end

  # shorten long URL
  def self.shorten_url(size = 7)
    charset = ('a'..'z').to_a + (0..9).to_a
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end
            
end
