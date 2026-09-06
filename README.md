README: Item Manager Application

Overview

The Item Manager is a Rails-based application for managing goods, generating QR codes, and tracking item quantities. This document outlines recent changes and improvements made to the project to resolve issues and enhance functionality.

Key Changes and Fixes

1. QR Code Generation

Fixed Issue: QR codes now embed the product name instead of just the ID.

Previously, QR codes included raw data such as {"name":"g","id":4}.

Now, the QR data is formatted as: name: ProductName, id: ProductID.

Implementation:

Updated the generate_qr_code method in the Good model:

def generate_qr_code
  qr_data = "name: #{brand}, id: #{id}"
  qr_code = RQRCode::QRCode.new(qr_data)
  png = qr_code.as_png(size: 200)
  FileUtils.mkdir_p(Rails.root.join('public', 'qrcodes'))
  File.open(Rails.root.join('public', 'qrcodes', "item_#{id}.png"), 'wb') { |f| f.write(png.to_s) }
end

2. Quantity Update Feature

Added Feature: Buttons for adding or removing quantities for goods.

Fixed Issue: Quantity updates were not properly reflecting in the database.

Implementation:

Added update_quantity action in the GoodsController.

Route: /goods/update_quantity.

Controller logic:

def update_quantity
  @good = Good.find_by(brand: params[:name])

  if @good.nil?
    render json: { error: "Product not found!" }, status: :not_found
    return
  end

  case params[:action_type]
  when "add"
    @good.increment!(:quantity, params[:amount].to_i)
  when "remove"
    if @good.quantity >= params[:amount].to_i
      @good.decrement!(:quantity, params[:amount].to_i)
    else
      render json: { error: "Not enough quantity to remove!" }, status: :unprocessable_entity
      return
    end
  else
    render json: { error: "Invalid action!" }, status: :unprocessable_entity
    return
  end

  render json: { message: "Quantity updated successfully! New quantity: #{@good.quantity}" }
end

3. Routing Improvements

Resolved Issue: Conflicts with update_quantity route and duplicate routes for Devise.

Implementation:

Consolidated routes in config/routes.rb:

resources :goods do
  member do
    get 'generate_qr'
  end
  collection do
    post 'update_quantity'
  end
end

devise_for :users, skip: [:sessions, :registrations]

4. Environment Variable Setup

Added necessary environment variables for deployment, such as SECRET_KEY_BASE.

5. Deployment Fixes

Fixed errors with Railway deployment:

Resolved database migration issues by running rails db:migrate during post-deployment.

Precompiled assets using:

rails assets:precompile

Addressed Invalid route name and Pending migration errors.

Next Steps

Testing:

Test all features thoroughly in staging before deploying to production.

Ensure quantity updates and QR code generation work as expected.

Documentation:

Update this README with any additional features or fixes.

Enhancements:

Add user roles for better control over goods management.

Implement UI improvements using Bootstrap.

How to Contribute

Fork the repository.

Create a feature branch for your changes.

Submit a pull request with a detailed description of your changes.

Contact

For any issues or inquiries, please contact the project maintainer at fazeents@gmail.com.

