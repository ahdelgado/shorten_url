require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  def setup
    @url = Url.new(long_url: "www.example.com", short_url: "example")
  end

  test "should be valid" do
    assert @url.valid?
  end
  
  test "should not produce duplicate short URLs" do
      duplicate_url = @url.dup
      duplicate_url.short_url = @url.short_url.upcase
      @url.save
      assert_not duplicate_url.valid?
  end
  
    test "should not produce short URL with inappropriate words" do
      @url.short_url = "foobar"
            
      while @url.short_url.scan(/foo|bar/).size > 0
        @url.short_url = Url.clean(@url.short_url)
      end
      assert @url.short_url.scan(/foo|bar/).size == 0
  end
      
    test "should accept long_url if valid URL format" do
    valid_urls = %w[userexample.com USERfoo.COM ERfoo.bar.org
                         first.lastfoo.net aj-scarlet.edu]
    
    valid_urls.each do |valid_url|
      @url.long_url = valid_url
      assert @url.valid?, "#{valid_url.inspect} should be valid"
    end
  end
  
    test "should reject long_url if invalid URL format" do
    invalid_urls = %w[userexample,com user_at_foo,org user.name@example.
                           foo@bar_baz@com foo@bar+baz,org]
                           
    invalid_urls.each do |invalid_url|
      @url.long_url = invalid_url
      assert_not @url.valid?, "#{invalid_url.inspect} should be invalid"
    end
    
  end
  
    test "should reject long_url if nil" do
      @url.long_url = nil
      assert_not @url.valid?
  end
    
end