
require 'rqrcode'
require 'fileutils'
require 'chunky_png'
class Good < ApplicationRecord
  belongs_to :user

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

has_many :scans, dependent: :destroy
class Good < ApplicationRecord
  belongs_to :user


end
