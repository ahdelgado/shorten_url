require 'digest'

class Url < ActiveRecord::Base
    
  VALID_URL_REGEX = /\A((http|https):\/\/)?[a-z0-9]+([\-\.]
                      {1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix

  VALID_CHARS = ('a'..'z').to_a + (0..9).to_a + ('A'..'Z').to_a
                      
  validates :long_url,  presence: true, uniqueness: true,
                    format: { with: VALID_URL_REGEX }
                                          

  def clean(long_url)
    # code here
  end

  # Hash long URL into short URL
  def shorten_url(long_url)
    if !Url.where(long_url: clean(long_url)).exists?
      short_url = Digest::MD5.hexdigest(long_url)
    end
    short_url
  end

  def base_url
    'http://willing/'
  end
            
end
