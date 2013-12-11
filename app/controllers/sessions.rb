Ilook::App.controllers :sessions do

  layout :customer
  
  get :new, :map => '/login' do
    render "sessions/new", nil
  end

  get :weibo, :map => "/login/weibo" do
    puts "login weibo call back #{params[:code]}"
    session[:weibo_code] = params[:code]
    params[:code]
  end

  get :logout, :map => '/logout' do
    set_current_account(nil)
    redirect_back_or_default('/')
  end

  post :create do
    #puts "params: #{params}"
    if account = Account.authenticate(params[:email],  params[:password])
      set_current_account(account)
      redirect_back_or_default('/')
    else
      params[:email], params[:password] = h(params[:email]), h(params[:password])
      flash[:error] = pat('login.error')
      redirect url(:sessions, :new)
    end

  end

end
