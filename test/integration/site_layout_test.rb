require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template 'urls/new'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", index_path
  end
end