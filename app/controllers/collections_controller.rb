class CollectionsController < InheritedResources::Base

  private

    def collection_params
      params.require(:collection).permit(:user_id, :item_id)
    end
end

