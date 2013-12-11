# -*- coding: utf-8 -*-
Ilook::App.controllers :account do
  
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
      
  get :register, :map => '/register' do
    @account = Account.new
    render 'account/register'
  end

  post :create do
    @account = Account.new(params[:account])
    @account.role = 'user'
    @account.active_code = random_string
    @account.expire_time = Time.now + (24 * 60 * 60)
    if @account.save
      #send verify email
      #generate verify code
      deliver(:nortify, :register_email, @account.name, @account)
      flash[:success] = '注册成功，请登入邮箱激活该账户'
    else
      flash.now[:error] = '注册失败'
      render 'account/register'
    end
  end

  get :verify, :map => 'account/verify' do 
    active_code = params[:active_code]
    email = params[:email]
    
    if account = Account.verify_email(email, active_code)
      flash[:success] = '帐号已经激活'
      set_current_account(account)
      redirect_back_or_default('/')
    else
      flash.now[:error] = '激活失败'
      set_current_account(nil)
      redirect_back_or_default('/register')
    end
  end

end
