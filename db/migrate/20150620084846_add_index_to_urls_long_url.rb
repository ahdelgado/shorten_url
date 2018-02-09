class AddIndexToUrlsLongUrl < ActiveRecord::Migration
  def change
    add_index :urls, :long_url, unique: true
  end
end
