class ScanController < ApplicationController
  def index
    @scans = Scan.includes(:good).order(scanned_at: :desc)
  end
  def qrcode
     @good = Good.find(params[:id]) # Ensure this fetches a valid `Good` object
     @qr_code_svg = @good.generate_qr_code.as_svg(
       offset: 0,
       color: '000',
       shape_rendering: 'crispEdges',
       module_size: 6,
       standalone: true
     )
   end
   def qrcode
    @goods = Good.all  # Fetch all goods to display in the table
  end

end
