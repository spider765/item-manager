<<<<<<< HEAD
=======

require 'rqrcode'
require 'fileutils'
require 'chunky_png'
>>>>>>> 08a872e0b0666f25adddb6cc6b5370a75589913d
class Good < ApplicationRecord
  belongs_to :user
  has_many :scans, dependent: :destroy

<<<<<<< HEAD
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
=======
  def generate_qr_code

    # Embed the product's name and ID in the QR code
 qr_data = "name: #{brand}, id: #{id}"
    # Generate QR code with the item's ID
qr_code = RQRCode::QRCode.new(qr_data)
    # Generate the PNG image
    png = qr_code.as_png(size: 200)

    # Ensure the directory exists
    FileUtils.mkdir_p(Rails.root.join('public', 'qrcodes'))

    # Save the PNG image to a file in public/qrcodes
    File.open(Rails.root.join('public', 'qrcodes', "item_#{id}.png"), 'wb') do |f|
      f.write(png.to_s)
    end
  end
end
>>>>>>> 08a872e0b0666f25adddb6cc6b5370a75589913d
