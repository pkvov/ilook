# -*- coding: utf-8 -*-

require 'pp'

Ilook::App.controllers :news do
  
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
    @section = 'news'
    @items = News.order('created_at desc').limit(20)
    render 'news/show'
  end

  get :search do
    @section = 'news'
    @items = News.search "上海"
    render 'news/show'
  end

  get :detail do
    
    @item = News.find(params[:id])
    render 'news/detail'
  end

end
