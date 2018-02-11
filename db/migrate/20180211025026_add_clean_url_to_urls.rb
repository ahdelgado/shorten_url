class AddCleanUrlToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :clean_url, :string
  end
end
