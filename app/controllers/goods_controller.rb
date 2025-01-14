class GoodsController < ApplicationController
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

  end

  # GET /goods/new
  def new
    @good = current_user.goods.build
  end

  # GET /goods/1/edit
  def edit

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

    if @good.nil?
      respond_with_error("Product not found!", :not_found)
      return
    end

    amount = params[:amount].to_i
  if amount <= 0
    respond_to do |format|
      format.html { redirect_to goods_path, alert: "Invalid amount specified!" }
      format.json { render json: { error: "Invalid amount specified!" }, status: :unprocessable_entity }
    end
    return
  end

    case params[:action_type]
    when "add"
      @good.increment!(:quantity, amount)
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
      return
    end

    respond_to do |format|
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
