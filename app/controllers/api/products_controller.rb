class Api::ProductsController < ApplicationController
  rescue_from ActionController::UnknownFormat, with: :raise_not_found

  def add
    message = "failed to add item"
    state = "error"
    item = params[:item]

    collection = Collection.where(user_id: current_user.id).order(:created_at).first_or_create
    new_item = collection.items.new( name: item["ItemAttributes"]["Title"], image: item["LargeImage"]["URL"], amazon_url: item["DetailPageURL"], ASIN: item["ASIN"])

    if new_item.save
      message = "Added item succesfully"
      state = "ok"
    end


    render json: { message: message, state: state }
  end

  def not_found
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def raise_not_found
    render file: "#{Rails.root}/public/404", layout: false, status: :not_found
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
