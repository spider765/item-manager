class AddQrDataToScans < ActiveRecord::Migration[7.1]
  def change
    add_column :scans, :qr_data, :string
  end
end
