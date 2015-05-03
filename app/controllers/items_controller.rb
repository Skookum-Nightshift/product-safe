class ItemsController < InheritedResources::Base

  private
    def index
      @items = Item.all

      
    end
    def item_params
      params.require(:item).permit(:collection_id, :expiration_date, :image, :barcode, :expiration_date, :amazon_url, :name)
    end
end

