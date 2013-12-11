# -*- coding: utf-8 -*-
require 'tilt/haml'
require 'mechanize'
require 'pp'

class SpiderHelper
  @@common_goods = ['长白菜', '菠菜', '胡萝卜', '芹菜', '藕', '青椒','黄瓜', '茄子', '西红柿', '苦瓜']
  #@@weibo_client = nil

  def self.save_one_day(market_id, date, goods, force_update = false, common_goods = @@common_goods)
    puts "save_one_day market_id:#{market_id} date:#{date}"
    pp goods
    if Goods.where(:market_id => market_id, :date => date).exists?
      if force_update && (goods.count > 0)
        #如果是强制刷新，则按照数据一个个更新, 多出的则导入到数据库        
        not_find_goods = goods.reject do |g|
          good = Goods.find_by_market_id_and_date_and_name(market_id, date, g.name)
          if good
            if g.category_id.nil?
              good.category_id = get_category_id(g.name) 
            else
              good.category_id = g.category_id
            end
            good.high = g.high
            good.low = g.low
            good.unit_id = g.unit_id
            good.save!
          end
          not good.nil?
        end
        Goods.import not_find_goods
      end
    else
      #auto generate brief news 
      auto_generate_news(market_id, date, goods, common_goods)
      Goods.import goods
      puts "import goods finished"
    end
  end

  def self.auto_generate_news(market_id, date, goods, common_goods)
    return if goods.nil? or goods.empty?

    date_string = Goods.select('max(date) as date').where("market_id = #{market_id}").first[:date]
    return if date_string.nil?
    latest_date = date_string.to_date
    #yestoday = date.to_date.prev_day
    puts "auto generate by latest_date #{latest_date}"
    
    market_name = Market.find_by_id(market_id).name
    puts "auto generate news #{market_name}"
    puts "auto generate news #{goods}"
    puts "auto generate news #{common_goods}"
    grows  = []
    declines = []
    shakes = []
    grow_count = 0
    decline_count = 0
    same_count = 0
    items = []
    goods.each do |good|
      latest_date_good = Goods.find_by_market_id_and_name_and_date(market_id, good.name, latest_date)
      if latest_date_good
        latest_date_avg = (latest_date_good.high + latest_date_good.low) / 2.0
        today_avg = (good.high + good.low) / 2.0
        diff_range = (today_avg - latest_date_avg) / latest_date_avg;
        if diff_range > 0
          grow_count += 1
        elsif diff_range < 0
          decline_count += 1
        else
          same_count += 1
        end
        amplitude = (good.high / good.low) - 1.0
        
        good.class.module_eval {attr_accessor :diff_range} if ! defined?(good.diff_range)
        good.diff_range = diff_range
        good.class.module_eval {attr_accessor :amplitude} if ! defined?(good.amplitude)
        good.amplitude = amplitude
        if goods.count <= common_goods.count
          items << good
        else
          items << good if common_goods.include?(good.name)
        end
        grows << good if (diff_range >= 0.1)
        declines << good if (diff_range <= -0.1)
        shakes << good if (amplitude >= 0.3)
      end
    end

    total_count = grow_count + decline_count + same_count
    return if total_count == 0
    brief = "#{market_name}"
    if grow_count / total_count > 0.5
      brief += "价格大幅上涨"
    elsif decline_count / total_count > 0.5
      brief += "价格大幅下跌"
    else
      if grow_count > decline_count
        brief += "价格平稳上涨"
      elsif grow_count = decline_count
        brief += "价格保持稳定"
      else
        brief += "价格平稳下跌"
      end
    end

    grows.sort!{|a, b| b.diff_range <=> a.diff_range}
    declines.sort!{|a, b| a.diff_range <=> b.diff_range}
    shakes.sort!{|a, b| b.amplitude <=> a.amplitude}

    s = ""
    s += get_names(grows, 3) + '价格涨幅较大 ' if grows.count > 0
    s += get_names(declines, 3) + '价格跌幅较大 ' if declines.count > 0
    s += get_names(shakes, 3) + '价格波动较大 ' if shakes.count > 0
    brief += ", " + s
    
    news_obj = Object.new
    news_obj.class.module_eval {attr_accessor :market_name}
    news_obj.class.module_eval {attr_accessor :date}
    news_obj.class.module_eval {attr_accessor :latest_date}
    news_obj.class.module_eval {attr_accessor :market_id}
    news_obj.class.module_eval {attr_accessor :total_count}
    news_obj.class.module_eval {attr_accessor :grow_count}
    news_obj.class.module_eval {attr_accessor :decline_count}
    news_obj.class.module_eval {attr_accessor :same_count}
    news_obj.class.module_eval {attr_accessor :grows}
    news_obj.class.module_eval {attr_accessor :declines}
    news_obj.class.module_eval {attr_accessor :shakes}
    news_obj.class.module_eval {attr_accessor :items}

    news_obj.market_name = market_name
    news_obj.date = date
    news_obj.latest_date = latest_date
    news_obj.market_id = market_id
    news_obj.total_count = total_count
    news_obj.grow_count = grow_count
    news_obj.decline_count =  decline_count
    news_obj.same_count = same_count
    news_obj.grows = grows
    news_obj.declines = declines
    news_obj.shakes = shakes
    news_obj.items = items

    news_template_file = File.join(Padrino.root, 'workers', 'config', 'news_quote.haml')
    template = Tilt.new(news_template_file)
    content = template.render(news_obj)
    News.create!(:title => "#{market_name}每日快讯",
                 :source => "农商圈",
                 :brief => brief,
                 :content_type => "html",
                 :content => content
                 )
    puts "news created brief:#{brief}"
  end
  
  def self.get_names(array, max)
    s = ""
    last = [array.count, max].min
    array.each_with_index {|v, i| 
      avg = '%.2f' % ((v.high + v.low) / 2.0)
      s += "#{v.name}(#{avg})"
      if i < last - 1
        s += "、"
      else
        break
      end
    }
    s += '等' if array.count > max
    s
  end

  def self.get_category_id(name)
    o = NameCategoryDic.find_by_name(name)
    if o
      o.category_id
    else
      puts "not find category: #{name}"
      nil
    end
  end

  def self.get_unit_id(name)
    o = Unit.find_by_name(name)
    if o
      o.id
    else
      puts "not find unit: #{name}"
      nil
    end
  end
end
