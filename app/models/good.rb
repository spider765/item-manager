class Good < ApplicationRecord
  belongs_to :user
  has_many :scans, dependent: :destroy

  # Generates a QR code PNG encoding this good's id and brand name as JSON,
  # and saves it to public/qrcodes/item_<id>.png.
  #
  # JSON is used instead of a hand-rolled "key: value, key: value" string so
  # that scanning it back (GoodsController#process_qr) can round-trip
  # reliably even if `brand` ever contains a comma or colon.
  def generate_qr_code
    qr_data = { id: id, name: brand }.to_json

    qr_code = RQRCode::QRCode.new(qr_data)
    png = qr_code.as_png(size: 200)

    qr_dir = Rails.root.join("public", "qrcodes")
    FileUtils.mkdir_p(qr_dir)

    File.open(qr_dir.join("item_#{id}.png"), "wb") do |f|
      f.write(png.to_s)
    end
  end
end