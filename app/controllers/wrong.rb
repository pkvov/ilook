Ilook::App.controllers :wrong do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end

  layout :customer

  get :index do
    #puts 'in wrong index'
    redirect url(:wrong, :edit), 301
  end

  get :edit do
    @items = Goods.where('(category_id is NULL) OR (unit_id is NULL)').group('name')
      .paginate(:page => params[:page],
                :per_page => 10,
                :order => 'date DESC')
    @categories = Category.all
    render '/wrong/edit'
  end

  get :category do
    @items = Goods.where('category_id is NULL').group('name')
      .paginate(:page => params[:page],
                :per_page => 10,
                :order => 'date DESC')
    @categories = Category.all
    render '/wrong/edit'
  end

  get :unit do 
    @items = Goods.where('unit_id is NULL').group('name')
      .paginate(:page => params[:page],
                :per_page => 10,
                :order => 'date DESC')
    @categories = Category.all
    render '/wrong/edit'      
  end
  
  post :update_category do
    update_items = params[:update_items]
    category_id = params[:category_id]

    if update_items && category_id
      Goods.transaction do 
        update_items.each do |key, value|
          Goods.change_name_category(value, category_id)
        end
      end
    end
    puts "update_category finished"
    redirect url(:wrong, :edit, :page => 1, :r => 123456789), 301
  end  

end
