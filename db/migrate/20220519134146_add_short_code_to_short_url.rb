class AddShortCodeToShortUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :short_urls, :shortcode, :string, null: false
  end
end
