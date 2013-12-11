# -*- coding: utf-8 -*-
#http://www.qxshucai.com/

require 'mechanize'
require File.expand_path('../spider_helper', __FILE__)

class Qxshucai

  def initialize
    @agent = Mechanize.new    
    # @agent.set_proxy 'localhost', 8087
    @agent.user_agent_alias = 'Windows Mozilla'
    @agent.pre_connect_hooks << lambda do |agent, request|
      sleep 1
    end
    
    @market_id = get_qiaoxi_market_id('石家庄桥西蔬菜中心批发市场')

    @unit_id_kilo = Unit.find_by_name("元/公斤").id
    @unit_id_jian = Unit.find_by_name("元/件").id    
    @unit_id_tong = Unit.find_by_name("元/桶").id
    @unit_id_dai = Unit.find_by_name("元/袋").id
    @unit_id_he = Unit.find_by_name("元/盒").id
  end

  def refresh_today
    url = 'http://www.qxshucai.com/SmallClass.asp?BigClassName=%CA%D0%B3%A1%BC%F2%BD%E9&SmallClassName=%BD%F1%C8%D5%BC%DB%B8%F1'
    page = @agent.get(url)
    today = "#{Time.now.year}-#{Time.now.month}-#{Time.now.day}"
    today_font = page.root.css('//font').select { |t| t.text.include?(today)}

    if today_font && (today_font.count > 0)
      #find today price quote link
      puts "today_font: #{today_font}"
      today_link = today_font[0].previous_sibling()
      news_id = get_news_id(today_link)
      puts "www.qxshucai.com update today's data, date:#{today}, news_id:#{news_id}"
      #todo: generate bref news report
      save_one_day_data(Time.now.to_date, news_id)
    end
  end

  def refresh_all
    page_count = get_page_count
    (1 .. page_count).each { |page_index|
      process_one_page(page_index)
    }
  end

  private

  def get_page_count
    url = 'http://www.qxshucai.com/SmallClass.asp?BigClassName=%CA%D0%B3%A1%BC%F2%BD%E9&SmallClassName=%BD%F1%C8%D5%BC%DB%B8%F1'
    page = @agent.get(url)
    lastPageLink = page.root.css('//a[@href]').select {|link| link.text == '页尾'}
    page_count = lastPageLink[0][:title].scan(/\d/).join.to_i
  end

  def process_one_page(page_index)
    url = "http://www.qxshucai.com/SmallClass.asp?BigClassName=%CA%D0%B3%A1%BC%F2%BD%E9&SmallClassName=%BD%F1%C8%D5%BC%DB%B8%F1&page=#{page_index}"
    current_page = @agent.get(url)
    
    #get all 价格总汇
    price_new_items = current_page.root.css('//a').select{|link| link.text == '价格总汇'}
    price_new_items.each { |item| 
      news_id = get_news_id(item)
      date_text = item.next_sibling
      if Padrino.env == :development
        return if Time.now.year != Date.parse(date_text).year
      end
      
      save_one_day_data(Date.parse(date_text), news_id, true)
    }
  end

  def save_one_day_data(date, news_id, force_update = false)
    url = "http://www.qxshucai.com/ReadNews.asp?NewsID=#{news_id}&BigClassName=%CA%D0%B3%A1%BC%F2%BD%E9&SmallClassName=%BD%F1%C8%D5%BC%DB%B8%F1&SpecialID=0"
    #open today's price link
    price_page = @agent.get(url)
    index = 0
    #find price table
    price_name = ""
    price1_txt = ""
    price2_txt = ""

    goods  = []

    price_page.root.css("//table.MsoNormalTable > tbody > tr > td").each do |item|
      if ["价格", "年", "单位", "品 种", "品  种", "品种", "最高价", "最低价"].all? {|word| 
          not item.text.include?(word) }

        if index == 0
          price_name = delete_white_space(item.text)
        elsif index == 1
          price1_txt = delete_white_space(item.text)
        elsif index == 2         
          price2_txt = delete_white_space(item.text)

          price1, unit1 = price1_txt.split(' ', 2)
          price2, unit2 = price2_txt.split(' ', 2)

          p1 = price1.strip.to_d unless price1.nil?
          p2 = price2.strip.to_d unless price2.nil?
          
          p_array = [p1, p2].reject {|v| v.nil?}
          if (not p_array.nil?) && (p_array.count > 0)
            high = p_array.max
            low = p_array.min

            if unit1 && unit1.strip != ""
              unit = unit1.strip
            end

            if unit2 && unit2.strip != ""
              unit = unit2.strip
            end

            if (price_name  == '香菇') and (low > 50)
              price_name = "干香菇"
            end

            #update if exists by name and date
            good = Goods.new
            good.name = price_name
            good.market_id = @market_id
            good.category_id = SpiderHelper.get_category_id(price_name)
            good.high = high
            good.low = low
            good.unit_id = get_qiaoxi_unit_id(price_name)
            good.date = date
            #puts "good:#{good}"
            goods << good
          end
        end
        index = (index + 1) % 3
      end
    end
    SpiderHelper.save_one_day(@market_id, date, goods, force_update)
  end

  def get_qiaoxi_market_id(name)
    Market.find_by_name(name).id
  end

  def get_qiaoxi_unit_id(name)
    a5 = ['金龙鱼花生油', '金龙鱼大豆油', '鲁花花生油', 
          '福临门花生油', '燕山酵母', '珍极酱油', 
          '珍极醋', '芥茉油', '十三香', '鸡粉', '番茄酱',
          '海带丝']
    a6= ['槐茂面酱']
    a7 = ['大百合', '小百合', '紫菜', '龙口粉丝']
    a8 = ['对虾']
    
    if a5.include?(name)
      return @unit_id_jian
    elsif a6.include?(name)
      return @unit_id_tong
    elsif a7.include?(name)
      return @unit_id_dai
    elsif a8.include?(name)
      return @unit_id_he
    else
      return @unit_id_kilo
    end
  end

  def get_news_id(link)
    key, value = link[:href].split('?', 2)
    news_id = CGI::parse(value)['NewsID'][0]
  end

  def delete_white_space(s)
    s = s.gsub('　', '')
    s = s.gsub(' ', '')
    s.strip        
  end


end
