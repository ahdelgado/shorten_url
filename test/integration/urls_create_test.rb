require 'test_helper'

class UrlsCreateTest < ActionDispatch::IntegrationTest
  test "invalid url information" do
    get root_path
    assert_no_difference 'Url.count' do
      post urls_path, url: { long_url:  "badurl",
                            short_url: nil}
    end
    assert_template 'urls/new'
  end
  
    test "valid url information" do
    get root_path
    assert_difference 'Url.count', 1 do
      post_via_redirect urls_path, url: { long_url:  "www.example1.com",
                                           short_url: nil}
    end
    assert_template 'urls/show'
  end
  
    test "should accomodate transcription ambiguities" do
      get root_path
      assert_difference 'Url.count', 1 do
        post urls_path, url: { long_url:  "www.0000000.com",
                            short_url: nil}
                            
        post urls_path, url: { long_url:  "www.OOOOOOO.com",
                            short_url: nil}
      end
      assert_template 'urls/new'
  end
  
end
