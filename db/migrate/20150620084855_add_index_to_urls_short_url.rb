class AddIndexToUrlsShortUrl < ActiveRecord::Migration
  def change
    add_index :urls, :short_url, unique: true
  end
end
