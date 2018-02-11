class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :urls, :clean_url, :url
  end
end