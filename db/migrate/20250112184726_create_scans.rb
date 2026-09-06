class CreateScans < ActiveRecord::Migration[7.1]
  def change
    create_table :scans do |t|
      t.references :good, null: false, foreign_key: true
      t.datetime :scanned_at

      t.timestamps
    end
  end
end
