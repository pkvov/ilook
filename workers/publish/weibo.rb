# -*- coding: utf-8 -*-
require 'singleton'
require 'weibo_2'
require 'mechanize'
require 'pp'

class WeiBo
  include Singleton

  def initialize
    @weibo_client = login_weibo
    @uid_array = @weibo_client.friendships.followers_ids.ids
    refresh_locate_array
  end

  def publish
    #publish with sina weibo
    if @weibo_client.nil? 
      @weibo_client = login_weibo
    end
    
    if @locate_array_refreshed_at.to_date != Time.now.to_date
      refresh_locate_array
    end

    #get news
    news_array = News.where("published_at is null").order("created_at asc").limit(10)
    news_array.each do |a_news|
      if not a_news.nil?
        status = a_news.brief
        #@粉丝中有地址信息的
        @locate_array.each do |item|
          if match_city(a_news, item[:location])
            temp = status + "@#{item[:name]} "
            status = temp if temp.length <= 140
          end
        end

        begin
          @weibo_client.statuses.update(status)
        rescue Exception => e
        ensure
          a_news.published_at = Time.now
          a_news.save!
        end
      end
    end
  end

  def refresh_locate_array
    @locate_array = []
    @uid_array.each do |uid|
      begin
        user = @weibo_client.users.show_by_uid(uid)
        locate_item = {:location => user.location, :name => user.name }
        @locate_array << locate_item
      rescue
      end
    end
    @locate_array_refreshed_at = Time.now
  end

  def client
    @weibo_client
  end

  def match_city(a_news, location)
    #location 北京 海淀区
    #location 河南 郑州
    #location 其他
    city = nil
    locates = location.split
    if locates.length == 2
      if location.include?('区')
        city = locates[0] 
      else
        city = locates[1]
      end
    end
    
    if not city.nil?
      a_news.title.include?(city)
    else
      false
    end
  end

  def login_weibo
    user = "pkvovboy@gmail.com"
    pwd = "Pk9521158"
    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Mozilla'
    agent.follow_meta_refresh = true 
    #config in boot.rb
    url = "https://api.weibo.com/oauth2/authorize?client_id=#{WeiboOAuth2::Config.api_key}&response_type=code&redirect_uri=#{WeiboOAuth2::Config.redirect_uri}"
    page = agent.get(url)
    mypage = page.form_with(:action => 'authorize') do |f|
      user_name_field = f.field_with(:name => "userId")
      user_name_field.value = user
      passwd_field = f.field_with(:name => "passwd")
      passwd_field.value = pwd
    end.submit
    
    weibo_code = mypage.body
    puts "weibo_code #{weibo_code}"
    client = WeiboOAuth2::Client.new
    client.auth_code.get_token(weibo_code)
    client
  end

end
