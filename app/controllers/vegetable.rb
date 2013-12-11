Ilook::App.controllers :vegetable do

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
    #render 'vegetable/index'
  end

  # get :news do
  #   @section = 'news'
  #   render 'vegetable/news'
  # end

  before :price do
    puts "settings.session_id #{settings.session_id}"
    puts "login_from_session #{login_from_session}"
    puts "allowed? /vegetable/price #{access_control.allowed?(current_account,  '/vegetable/price')}"
  end

  get :price do
  # :map => 'vegetable/price/:area_id/:market_id/:category_id/:date' 

    @section = 'price'
    current_area_id = params[:area_id]
    current_market_id = params[:market_id]
    current_category_id = params[:category_id]
    current_date = params["date"]
    @filter = {:areas => Area.all,
      :markets  => (Market.where("area_id = #{current_area_id}") if current_area_id && (not current_area_id.empty?)),
      :categories => Category.all,
      :current_area_id => current_area_id,
      :current_market_id => current_market_id,
      :current_category_id => current_category_id,
      :current_date =>  current_date
    }
    #puts @filter
    # where_string = ""
    # where_string += " market_id == #{params[:market_id]}" if params[:market_id] && (not params[:market_id].empty?)
    # where_string += " AND category_id == #{params[:category_id]}" if params[:category_id] && (not params[:category_id].empty?)
    # where_string += " AND date == #{params['date']}" if params[:date] && (not params['date'].empty?)
    
    conditions_hash = Hash.new
    conditions_hash[:market_id] = params[:market_id] if params[:market_id] && (not params[:market_id].empty?)
    conditions_hash[:category_id] = params[:category_id] if params[:category_id] && (not params[:category_id].empty?)
    if params["date"] && (not params["date"].empty?)
      conditions_hash["date"] = params["date"] 
    end
    
    puts conditions_hash
    
    @items = Goods.paginate(:page => params[:page],
                            :per_page => 10,
                            :conditions => conditions_hash,
                            :order => 'date DESC')
    
    # if where_string.empty? then
    #   @items = nil
    # else
    #   @items = Goods.where(where_string)
    # end
    render 'vegetable/price'
  end

  get :show do
    #:map => '/vegetable/:market_id/:date'
    @items = Goods.where("market_id = :market_id AND date = :date", params)
    render 'vegetable/show'
  end

  get :show, :map => '/category/:category_id' do
    @section = "category#{params[:category_id]}"
    
    
    #@items = Goods.where("category_id == :category_id AND date == (select max(date) from goods where category_id == :category_id)", {:category_id => params[:category_id]})
    # @items = Goods.paginate(:page => params[:page], 
    #                         :per_page => 10, 
    #                         :conditions => ["category_id = ? and date = (select max(date) from goods where category_id = ?)", params[:category_id], params[:category_id] ],
    #                         :order => :date)
    @items = Goods.where("category_id = ? and date = (select max(date) from goods where category_id = ?)", 
                         params[:category_id], params[:category_id]).paginate(:page => params[:page], :per_page => 10, :order => :date)
                            
    render 'vegetable/show'
  end

  get :qxshucai do
    RefreshQuoteQxshucai.perform_async
  end

  get :vegnet do
    RefreshQuoteVegnet.perform_async
  end

  get :picture do
    RefreshGooglePic.perform_async
  end

  get :qxshucai_all do
    RefreshHisQxshucai.perform_async
  end

  get :vegnet_all do 
    RefreshHisVegnet.perform_async
  end

  get :trend do
    GenerateTrend.perform_async
  end
  
end
