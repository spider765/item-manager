class GoodsController < ApplicationController
<<<<<<< HEAD
  before_action :set_good, only: %i[show edit update destroy generate_qr]
  before_action :authenticate_user!, except: %i[index show qrcode search]
  before_action :correct_user, only: %i[edit update destroy generate_qr update_quantity]

  # Only skip CSRF verification for JSON API requests; keep it enforced for
  # normal HTML form submissions (login-session-based actions like
  # create/update/destroy remain protected against cross-site forgery).
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  # GET /goods
  def index
    @goods = Good.all
  end

  # GET /goods/1
  def show
=======
  before_action :set_good, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]

protect_from_forgery with: :null_session


  # GET /goods or /goods.json
  def index
    @goods = Good.all
  end
def qrcode
 @goods = Good.all
end
def search
@goods =Good.where("brand LIKE ?", "%"+ params[:q] +"%")
end
  # GET /goods/1 or /goods/1.json
  def show

>>>>>>> 08a872e0b0666f25adddb6cc6b5370a75589913d
  end

  # GET /goods/new
  def new
    @good = current_user.goods.build
  end

  # GET /goods/1/edit
  def edit
<<<<<<< HEAD
  end

  # GET /goods/qrcode
  def qrcode
    @goods = Good.all
  end

  # GET /goods/search
  def search
    query = params[:q].to_s.strip

    @goods = if query.present?
               Good.where("brand LIKE ?", "%#{query}%")
             else
               Good.none
             end
  end

  # GET /goods/:id/generate_qr
  def generate_qr
    @good.generate_qr_code

    file_path = Rails.root.join("public", "qrcodes", "item_#{@good.id}.png")

    unless File.exist?(file_path)
      return render json: { error: "QR code could not be generated." }, status: :internal_server_error
    end

    send_file(file_path, type: "image/png", disposition: "inline")
  end

  # POST /goods
  def create
    @good = current_user.goods.build(good_params)

    respond_to do |format|
      if @good.save
        format.html do
          redirect_to good_url(@good), notice: "Good was successfully created."
        end

        format.json do
          render :show, status: :created, location: @good
        end
      else
        format.html do
          render :new, status: :unprocessable_entity
        end

        format.json do
          render json: @good.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /goods/1
  def update
    respond_to do |format|
      if @good.update(good_params)
        format.html do
          redirect_to good_url(@good), notice: "Good was successfully updated."
        end

        format.json do
          render :show, status: :ok, location: @good
        end
      else
        format.html do
          render :edit, status: :unprocessable_entity
        end

        format.json do
          render json: @good.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /goods/1
  def destroy
    if @good.destroy
      respond_to do |format|
        format.html do
          redirect_to goods_url, notice: "Item was successfully destroyed."
        end

        format.json do
          head :no_content
        end
      end
    else
      respond_with_error(@good.errors.full_messages.join(", "))
    end
  end

  # GET /goods/scan
  def scan
  end

  # POST /goods/process_qr
  #
  # Scanning an item is treated as "this unit is leaving inventory" — every
  # successful scan removes exactly 1 from quantity, atomically, so two
  # people scanning the same item at the same moment can't both succeed
  # past zero stock.
  def process_qr
    qr_data = params[:qr_data].to_s

    begin
      parsed_data = JSON.parse(qr_data)
    rescue JSON::ParserError
      render json: { error: "Invalid QR code data" }, status: :unprocessable_entity
      return
    end

    @good = Good.find_by(id: parsed_data["id"])

    if @good.nil?
      render json: { error: "Product not found!" }, status: :not_found
      return
    end

    unless @good.user_id == current_user.id
      render json: { error: "You are not authorized to modify this item." }, status: :forbidden
      return
    end

    # Atomic conditional decrement: only succeeds if there's at least 1 in
    # stock, and the check + decrement happen as one DB operation so a
    # concurrent scan of the same item can't also sneak through.
    updated_rows = Good
                    .where(id: @good.id)
                    .where("quantity >= ?", 1)
                    .update_all("quantity = quantity - 1")

    if updated_rows.zero?
      render json: {
        error: "#{@good.brand} is out of stock — nothing left to remove.",
        good: { id: @good.id, brand: @good.brand, quantity: @good.quantity }
      }, status: :unprocessable_entity
      return
    end

    @good.reload

    @good.scans.create!(qr_data: qr_data, scanned_at: Time.current)

    render json: {
      message: "#{@good.brand} scanned — 1 unit removed from inventory.",
      good: {
        id: @good.id,
        brand: @good.brand,
        quantity: @good.quantity
      }
    }
  end

  # POST /goods/update_quantity
  #
  # `correct_user` (via before_action) has already loaded @good for the
  # current user's own record when the good is found by id. This action is
  # invoked by brand/code lookup instead, so ownership is re-checked
  # explicitly below.
  def update_quantity
    @good = Good.find_by(id: params[:id]) ||
            Good.find_by(code: params[:code]) ||
            Good.find_by(brand: params[:name])
=======

  end


  def qrcode
    @goods = Good.all  # Fetch all goods or filter if needed

    respond_to do |format|
      format.html  # Render the qrcode view (a table with all QR codes)
    end
  end


  def generate_qr
    @good = Good.find(params[:id])  # Find the good by its ID

    # Generate the QR code (PNG format)
    @good.generate_qr_code  # Ensure this method generates the PNG and saves it

    # Serve the generated PNG image directly
    send_file Rails.root.join('public', 'qrcodes', "item_#{@good.id}.png"), type: 'image/png', disposition: 'inline'
  end


    # POST /goods or /goods.json
    def create

      @good = current_user.goods.build(good_params)

      respond_to do |format|
        if @good.save
          format.html { redirect_to good_url(@good), notice: "Good was successfully created." }
          format.json { render :show, status: :created, location: @good }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @good.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /goods/1 or /goods/1.json
    def update
      respond_to do |format|
        if @good.update(good_params)
          format.html { redirect_to good_url(@good), notice: "Good was successfully updated." }
          format.json { render :show, status: :ok, location: @good }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @good.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /goods/1 or /goods/1.json
    def destroy
      @good.destroy!

      respond_to do |format|
        format.html { redirect_to goods_url, notice: "Item was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_good

        if params[:id]
   @good = Good.find_by(id: params[:id])
 elsif params[:name]
   @good = Good.find_by(brand: params[:name])
 end

 unless @good
   render json: { error: "Good not found!" }, status: :not_found
 end
      end

      # Only allow a list of trusted parameters through.
      def good_params
        params.require(:good).permit(:brand, :price, :colour, :code, :quantity, :size, :user_id)
      end
      def correct_user
        @good = current_user.goods.find_by(id: params[:id])
        redirect_to root_path, notice: "You are not friends with them!" if @good.nil?
      end


    def scan
    # This just renders the view with the QR code scanner
  end


    def process_qr
 qr_data = params[:qr_data] # e.g., "name: g, id: 4"


        parsed_data = qr_data.split(', ').map { |pair| pair.split(': ').map(&:strip) }.to_h

   name = parsed_data["name"]
   id = parsed_data["id"].to_i



      # Find the good by name (ensure product names are unique)
      @good = Good.find_by(brand: qr_data['name'])

      if @good
        render json: {
          message: "Product found: #{@good.brand}",
          options: {
            add_quantity: true,
            remove_quantity: true
          }
        }
      else
        render json: { error: "Product not found!" }, status: :not_found
      end
    end

    def update_quantity
    @good = Good.find_by(brand: params[:name])
>>>>>>> 08a872e0b0666f25adddb6cc6b5370a75589913d

    if @good.nil?
      respond_with_error("Product not found!", :not_found)
      return
    end

<<<<<<< HEAD
    unless @good.user_id == current_user.id
      respond_with_error("You are not authorized to modify this item.", :forbidden)
      return
    end

    amount = params[:amount].to_i

    if amount <= 0
      respond_with_error("Invalid amount specified!", :unprocessable_entity)
      return
    end
=======
    amount = params[:amount].to_i
  if amount <= 0
    respond_to do |format|
      format.html { redirect_to goods_path, alert: "Invalid amount specified!" }
      format.json { render json: { error: "Invalid amount specified!" }, status: :unprocessable_entity }
    end
    return
  end
>>>>>>> 08a872e0b0666f25adddb6cc6b5370a75589913d

    case params[:action_type]
    when "add"
      @good.increment!(:quantity, amount)
<<<<<<< HEAD
      message = I18n.t("goods.quantity_added", quantity: @good.quantity)

    when "remove"
      # Atomic conditional decrement at the database level. This avoids the
      # read-check-then-write race condition of the previous implementation,
      # where two concurrent requests could both pass the `quantity >= amount`
      # check before either one actually decremented the value.
      updated_rows = Good
                      .where(id: @good.id)
                      .where("quantity >= ?", amount)
                      .update_all(["quantity = quantity - ?", amount])

      if updated_rows.zero?
        respond_with_error(I18n.t("goods.not_enough_quantity"))
        return
      end

      @good.reload
      message = I18n.t("goods.quantity_removed", quantity: @good.quantity)

    else
      respond_with_error(I18n.t("goods.invalid_action"))
=======
      message = I18n.t('goods.quantity_added', quantity: @good.quantity)
    when "remove"
      if @good.quantity >= amount
        @good.decrement!(:quantity, amount)
        message = I18n.t('goods.quantity_removed', quantity: @good.quantity)
      else
        respond_with_error(I18n.t('goods.not_enough_quantity'))
        return
      end
    else
      respond_with_error(I18n.t('goods.invalid_action'))
>>>>>>> 08a872e0b0666f25adddb6cc6b5370a75589913d
      return
    end

    respond_to do |format|
<<<<<<< HEAD
      format.html do
        redirect_to goods_path, notice: message
      end

      format.json do
        render json: { message: message }
=======
      format.html { redirect_to goods_path, notice: message }
      format.json { render json: { message: message } }
  # POST /goods or /goods.json
end
end
  def create

    @good = current_user.goods.build(friend_params)

    respond_to do |format|
      if @good.save
        format.html { redirect_to good_url(@good), notice: "Good was successfully created." }
        format.json { render :show, status: :created, location: @good }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @good.errors, status: :unprocessable_entity }
>>>>>>> 08a872e0b0666f25adddb6cc6b5370a75589913d
      end
    end
  end

<<<<<<< HEAD
  private

  def set_good
    @good = Good.find(params[:id])
  end

  # NOTE: :user_id is intentionally NOT permitted here. Ownership is set
  # once via `current_user.goods.build` on create and must never be
  # client-assignable, or a request could reassign a good to another user
  # or claim ownership of one on creation.
  def good_params
    params.require(:good).permit(
      :brand,
      :price,
      :colour,
      :code,
      :quantity,
      :size
    )
  end

  # Ensures the current user actually owns @good before allowing an
  # edit/update/destroy/generate_qr/update_quantity action to proceed.
  # Without this, any authenticated user could act on any record by id.
  def correct_user
    return if @good.nil? # let set_good's RecordNotFound surface normally

    unless @good.user_id == current_user.id
      redirect_to root_path, alert: "You are not authorized to access this item."
    end
  end

  def respond_with_error(message, status = :unprocessable_entity)
    respond_to do |format|
      format.html do
        redirect_to goods_path, alert: message
      end

      format.json do
        render json: { error: message }, status: status
      end
    end
  end
end
=======
  # PATCH/PUT /goods/1 or /goods/1.json
  def update
    respond_to do |format|
      if @good.update(good_params)
        format.html { redirect_to good_url(@good), notice: "Good was successfully updated." }
        format.json { render :show, status: :ok, location: @good }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @good.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goods/1 or /goods/1.json
  def destroy
    @good.destroy!

    respond_to do |format|
      format.html { redirect_to goods_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def respond_with_error(message, status = :unprocessable_entity)
    respond_to do |format|
      format.html { redirect_to goods_path, alert: message }
      format.json { render json: { error: message }, status: status }
    end
  end


    # Use callbacks to share common setup or constraints between actions.
    def set_good
      @good = Good.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def good_params
      params.require(:good).permit(:brand, :price, :colour, :code, :quantity, :size, :user_id)
    end
    def correct_user
      @good = current_user.goods.find_by(id: params[:id])
      redirect_to root_path, notice: "You are not friends with them!" if @good.nil?
    end

end
>>>>>>> 08a872e0b0666f25adddb6cc6b5370a75589913d
