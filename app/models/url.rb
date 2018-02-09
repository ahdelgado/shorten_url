require "base64"

class Url < ActiveRecord::Base
    
  VALID_URL_REGEX = /\A((http|https):\/\/)?[a-z0-9]+([\-\.]
                      {1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
                      
  validates :long_url,  presence: true, uniqueness: true,
                    format: { with: VALID_URL_REGEX }
                                          
  
  # Hash long URL into short URL
  def self.generate(long_url)
    url = Url.where(long_url: long_url).create
    
    # Make sure 0 and O are treated identically
    

    url.short_url = 'http://' << Base64.urlsafe_encode64(long_url)[8..15]
    url
  end
  
  #Remove inappropriate words (foo and bar) from short URL
  def self.clean(short_url)
      short_url = short_url.split("").shuffle.join
      short_url
  end
            
end
