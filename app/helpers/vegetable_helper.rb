# Helper methods defined here can be accessed in any controller or view in the application

Ilook::App.helpers do
  # def simple_helper_method
  #  ...
  # end

  def get_date_changed_url()
    "/vegetable/price?area_id=#{@filter[:current_area_id]}&market_id=#{@filter[:current_market_id]}&category_id=#{@filter[:current_category_id]}&date="
  end

end
