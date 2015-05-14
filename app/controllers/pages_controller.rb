class PagesController < ApplicationController
  rescue_from ActionController::UnknownFormat, with: :raise_not_found
  rescue_from ActionView::MissingTemplate do render '/generic_page' end
  after_action :allow_iframe

  def index
    if user_signed_in?
      @whiteLogo = view_context.image_url("Vault-Web-White.svg")
      @component_name = "MySafe"
      @url = "/"
      @api_url = "/api/pages/home"
    else
      redirect_to '/users/sign_in'
    end
  end

  def add
    if user_signed_in?
      @whiteLogo = view_context.image_url("Vault-Web-White.svg")
      @component_name = "AddItemView"
      @url = "/add"
      @api_url = "/api/pages/add"
    else
      redirect_to '/users/sign_in'
    end
  end

  # def item
  #   @component_name = "MyItemView"
  #   @url = "/item/#{params[:id]}"
  #   @api_url = "/api/item/#{params[:id]}"
  # end

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
