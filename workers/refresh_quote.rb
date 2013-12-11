# -*- coding: utf-8 -*-
Dir[File.expand_path('../source/*.rb', __FILE__)].each{|file| 
  puts file
  #require file 
  load file
}

Dir[File.expand_path('../publish/*.rb', __FILE__)].each{|file| 
  puts file
  #require file 
  load file
}


require 'clockwork'
require 'sidekiq'

#Worker 都需要可重复执行

#刷新各个数据源的新增的数据
class RefreshQuoteQxshucai
  include Sidekiq::Worker
  
  def perform
    #桥西蔬菜
    puts 'refreshquote Qxshucai'
    qxshucai = Qxshucai.new
    qxshucai.refresh_today    
  end
end

class RefreshQuoteVegnet
  include Sidekiq::Worker
  
  def perform
    #中国蔬菜网
    puts 'refreshquote Vegnet'
    vegnet = Vegnet.new
    vegnet.refresh_today
  end

end

class RefreshQuoteYz88
  include Sidekiq::Worker
  
  def perform
    #养猪88
    puts 'refreshquote Yz88'
    Yz88.new.refresh_today
  end

end

#刷新历史的数据
class RefreshHisQxshucai
  include Sidekiq::Worker

  def perform
    puts 'refreshhis qxshucai'    
    qxshucai = Qxshucai.new
    qxshucai.refresh_all
  end
end

class RefreshHisVegnet
  include Sidekiq::Worker

  def perform
    puts 'refresh his vegnet'    
    vegnet = Vegnet.new
    vegnet.refresh_all
  end
  
end

class RefreshHisYz88
  include Sidekiq::Worker

  def perform
    puts 'refresh his Yz88'    
    Yz88.new.refresh_all
  end
  
end

#刷新Google图片
class RefreshGooglePic
  include Sidekiq::Worker

  def perform
    puts 'Google pictures'
    google_pic = GooglePicture.new
    google_pic.start
  end
end

#生成走势图
class GenerateTrend
  include Sidekiq::Worker

  def perform
    puts "GenerateTrend"
    trend = TrendGraph.new
    trend.generate
  end

end

#发布微博
class PublishWeibo
  include Sidekiq::Worker

  def perform
    puts "Publish Weibo"
    WeiBo.instance.publish
  end
end


module Clockwork
  # Kick off a bunch of jobs early in the morning
  every 1.day,  'GooglePicture', :at => '00:48' do
    RefreshGooglePic.perform_async
  end

  every 1.day, "GenerateTrend", :at => '02:00'  do
    GenerateTrend.perform_async
  end

  every 1.hour, "RefreshQuoteQxshucai" do
    RefreshQuoteQxshucai.perform_async
    RefreshQuoteVegnet.perform_async
    RefreshQuoteYz88.perform_async
  end

  every 5.minute, "PublishWeibo" do
    PublishWeibo.perform_async
  end

end
