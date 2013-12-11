# -*- coding: utf-8 -*-
# http://www.yz88.cn

require 'mechanize'
require 'pp'
require File.expand_path('../spider_helper', __FILE__)

class Yz88
  def initialize
    @agent = Mechanize.new
    # @agent.set_proxy 'localhost', 8087
    @agent.user_agent_alias = 'Windows Mozilla'
    @agent.pre_connect_hooks << lambda do |agent, request|
      sleep 1
    end

    #从http://nc.mofcom.gov.cn/新农村商网抓取
    @market_array = [
                     '上海农产品中心批发市场有限公司',
                     '上海市曹安批发市场',
                     '云南省呈贡县龙城蔬菜批发市场',
                     '云南通海金山蔬菜批发市场',
                     '内蒙古包头市友谊蔬菜批发市场',
                     '内蒙古美通食品批发市场',
                     '内蒙古赤峰西城蔬菜批发市场',
                     '北京丰台区新发地农产品批发市场',
                     '北京城北回龙观商品交易市场',
                     '北京市华垦岳各庄批发市场',
                     '北京市日上综合商品批发市场',
                     '北京市通州八里桥农产品中心批发市场',
                     '北京市锦绣大地农副产品批发市场',
                     '北京市锦绣大地玉泉路粮油批发市场',
                     '北京新发地农产品批发市场 ',
                     '北京昌平水屯农副产品批发市场',
                     '北京朝阳区大洋路农副产品批发市场',
                     '北京通州八里桥农产品中心批发市场',
                     '北京顺义区顺鑫石门农产品批发市场',
                     '南京农副产品物流中心',
                     '南京紫金山批发市场',
                     '南京高淳县水产批发市场有限公司',
                     '南方粮食交易市场',
                     '吉林松原市三井子杂粮杂豆产地批发市场',
                     '吉林辽源市物流园区仙城水果批发市场',
                     '吉林长春果品中心批发市场',
                     '吉林长春江山绿特优农产品储运批发市场',
                     '呼和浩特市东瓦窑批发市场',
                     '嘉兴水果市场',
                     '四川凉山州会东县堵格乡牲畜交易市场',
                     '四川凉山州西昌市广平农副土特产品市场',
                     '四川南充北川农产品批发市场',
                     '四川广安邻水县农产 ',
                     '四川广安邻水县农产品交易中心',
                     '四川成都西部禽蛋批发市场',
                     '四川成都龙泉聚和果蔬菜交易中心',
                     '四川汉源县九襄农产品批发市场',
                     '四川泸州仔猪批发市场',
                     '四川省成都市农产品批发中心',
                     '四川省江油仔猪批发市场',
                     '四川绵阳市高水蔬菜批发市场',
                     '大连双兴批发市场',
                     '天津何庄子批发市场',
                     '天津市东丽区金钟蔬菜市场',
                     '天津市武清区大沙河蔬菜批发市场',
                     '天津市西青区当城蔬菜批发市场',
                     '天津市西青区红旗农贸批发市场',
                     '天津市韩家墅农产品批发市场',
                     '天津范庄子蔬菜批发市场',
                     '太原市河西农副产品市场',
                     '宁夏吴忠市利通区东郊果蔬批发市场',
                     '宁夏银川市北环批发市场',
                     '宁波江北名特优农副产品批发交易市场',
                     '安徽亳州蔬菜批发市场',
                     '安徽六安裕安区紫竹林农产品批发市场',
                     '安徽合肥周谷堆农产品批发市场',
                     '安徽和县皖江蔬菜批发大市场',
                     '安徽安庆市龙狮桥蔬菜批发市场',
                     '安徽省阜阳农产品中心批发市场',
                     '安徽砀山农产品中心惠丰批发市场',
                     '安徽舒城蔬菜大市场',
                     '安徽蚌埠蔬菜批发市场',
                     '安徽马鞍山安民农副产品批发交易市场',
                     '山东临邑县临南蔬菜大市场',
                     '山东冠县社庄江北第一蔬菜批发市场',
                     '山东匡山农产品综合交易市场',
                     '山东宁津县东崔蔬菜市场合作社',
                     '山东宁阳县白马蔬菜批发市场',
                     '山东寿光批发市场',
                     '山东德州黑马农产品批发市场',
                     '山东济南市堤口果品批发市场',
                     '山东滕州蔬菜批发市场',
                     '山东滨州市滨城区(六街)鲁北无公害蔬菜批发',
                     '山东滨州市滨城区(六街)鲁北无公害蔬菜批发市场',
                     '山东省威海市农副产品批发市场',
                     '山东省威海市水产品批发市场',
                     '山东省淄博市鲁中果品批发市场',
                     '山东章丘刁镇蔬菜批发市场',
                     '山东肥城蔬菜批发市场',
                     '山东金乡县蔬菜批发市场',
                     '山东青岛城阳蔬菜水产品批发市场',
                     '山东青岛市沧口蔬菜副食品批发市场',
                     '山东青岛市沧口蔬菜副食品批发市场 ',
                     '山东青岛平度市南村蔬菜批发市场',
                     '山东青岛莱西东庄头蔬菜批发',
                     '山东龙口果蔬批发市场',
                     '山西右玉玉羊批发市场',
                     '山西太原市城东利民果菜批发市场',
                     '山西孝义蔬菜批发交易市场',
                     '山西忻州市五台县东冶镇蔬菜瓜果批发市场',
                     '山西晋城绿欣农产品批发市场',
                     '山西朔州市应县南河种蔬菜批发市场',
                     '山西汾阳市晋阳农副产品批发市场',
                     '山西省临汾市尧丰农副产品批发市场',
                     '山西省临汾市襄汾县农副产品批发市场',
                     '山西省吕梁离石马茂庄农贸批发市场',
                     '山西省大同市南郊区振华蔬菜批发市场',
                     '山西省朔州市朔城区大运蔬菜批发市场',
                     '山西省汇隆商城',
                     '山西运城市蔬菜批发市场',
                     '山西长治市紫坊农副产品综合交易市场',
                     '山西长治市金鑫瓜果批发市场',
                     '山西阳泉蔬菜瓜果批发市场',
                     '广东东莞大京九农副产品中心批发市场',
                     '广东东莞果菜副食交易市场',
                     '广东汕头农副产品批发中心',
                     '广东江门市新会区水果食品批发市场有限公司',
                     '广东江门市水产冻品副食批发市场',
                     '广东省广州市江南农副产品市场',
                     '广西南宁五里亭蔬菜批发市场',
                     '广西柳州柳邕农副产品批发市场',
                     '广西田阳县果蔬菜批发市场',
                     '新疆乌尔禾蔬菜批发市场',
                     '新疆乌鲁木齐北园春批发市场',
                     '新疆乌鲁木齐市凌庆蔬菜果品有限公司',
                     '新疆伊犁哈萨克族自治州霍城县界梁子66团农贸市场',
                     '新疆兵团农二师库尔勒市孔雀农副产品综合批发市场',
                     '新疆博乐市农五师三和市场',
                     '新疆吐鲁番盛达葡萄干市场',
                     '新疆焉耆县光明农副产品综合批发市场',
                     '新疆石河子西部绿珠果蔬菜批发市场',
                     '新疆米泉通汇农产品批发市场',
                     '新疆维吾尔自治区克拉玛依农副产品批发市场',
                     '晋城绿盛农业技术开发有限公司',
                     '晋新绛蔬菜批发市场',
                     '晋运城果品中心市场',
                     '杭州农副产品物流中心',
                     '武汉市皇经堂批发市场',
                     '江苏丰县南关农贸市场',
                     '江苏凌家塘农副产品批发市场',
                     '江苏宜兴蔬菜副食品批发市场',
                     '江苏常州宣塘桥水产品交易市场',
                     '江苏建湖水产批发市场',
                     '江苏徐州七里沟农副产品中心',
                     '江苏扬州联谊农副产品批发市场',
                     '江苏无锡天鹏集团公司',
                     '江苏无锡朝阳市场',
                     '江苏淮海蔬菜批发市场',
                     '江苏苏州南环桥农副产品批发市场',
                     '江西上饶市赣东北农产品批发大市场',
                     '江西乐平市蔬菜开发总公司',
                     '江西九江市浔阳蔬菜批发大市场',
                     '江西南昌农产品中心批发市场',
                     '江西永丰县蔬菜中心批发市场',
                     '江西赣州南北蔬菜大市场',
                     '沧州红枣交易市场',
                     '河北三河市建兴农副产品批发市场',
                     '河北乐亭县冀东果蔬批发市场',
                     '河北保定工农路蔬菜果品批发市场',
                     '河北省威县瓜菜批发市场',
                     '河北省怀来县京西果菜批发市场',
                     '河北省永年县南大堡市场',
                     '河北省邯郸市（馆陶）金凤禽蛋农贸批发市场',
                     '河北秦皇岛海阳农副产品批发市场',
                     '河北秦皇岛（昌黎）农副产品批发市场',
                     '河北衡水市东明蔬菜批发市场',
                     '河北邯郸（魏县）天仙果品农贸批发交易市场',
                     '河北饶阳县瓜菜果品交易市场',
                     '河南三门峡西原店蔬菜批发市场',
                     '河南信阳市平桥区豫信花生制品有限公司',
                     '河南商丘市农产品中心批发市场',
                     '河南安阳豫北蔬菜批发市场',
                     '河南新野县蔬菜批发交易市场',
                     '河南省濮阳市王助蔬菜瓜果批发市场',
                     '河南郑州市农产品物流配送中心',
                     '河南郑州毛庄蔬菜批发市场',
                     '济南七里堡蔬菜综合批发市场',
                     '浙江义乌农贸城',
                     '浙江农都农副产品批发市场',
                     '浙江嘉兴蔬菜批发交易市场',
                     '浙江嘉善浙北果蔬菜批发交易',
                     '浙江宁波市蔬菜副食品批发交易市场',
                     '浙江温州菜篮子集团',
                     '浙江省杭州笕桥蔬菜批发交易市场',
                     '浙江省金华农产品批发市场',
                     '浙江绍兴蔬菜果品批发交易中心',
                     '湖北十堰市堰中蔬菜批发市场',
                     '湖北孝感市南大批发市场',
                     '湖北宜昌金桥蔬菜果品批发市场',
                     '湖北武汉白沙洲农副产品大市场',
                     '湖北洪湖市农贸市场',
                     '湖北浠水市城北农产品批发大市场',
                     '湖北潜江市江汉农产品大市场',
                     '湖北省鄂州市蟠龙蔬菜批发交易市场',
                     '湖北省黄石市农副产品批发交易公司',
                     '湖南岳阳花板桥批发市场',
                     '湖南常德甘露寺蔬菜批发市场',
                     '湖南益阳市团洲蔬菜批发市场',
                     '湖南省吉首市蔬菜果品批发大市场',
                     '湖南衡阳西园蔬菜批发市场',
                     '湖南邵阳市江北农产品大市场',
                     '湖南长沙红星农副产品大市场',
                     '湖南长沙马王堆蔬菜批发市场',
                     '甘肃天水瀛池果菜批发市场',
                     '甘肃定西市安定区马铃薯批发市场',
                     '甘肃省武山县洛门蔬菜批发市场',
                     '甘肃省陇西县首阳镇蔬菜果品批发市场',
                     '甘肃秦安县果品市场',
                     '甘肃腾胜农产品集团',
                     '甘肃酒泉春光农产品市场',
                     '甘肃靖远县瓜果蔬菜批发市场',
                     '石家庄桥西蔬菜中心批发市场',
                     '福建同安闽南果蔬批发市场',
                     '福建福鼎闽浙边界农贸中心市场',
                     '荷花坑批发市场',
                     '豫南阳果品批发交易中心',
                     '贵州贵阳市五里冲农副产品批发市场',
                     '贵州遵义坪丰农副产综合批发市场',
                     '贵州遵义市虾子辣椒批发市场',
                     '贵州铜仁地区玉屏畜禽产地批发市场',
                     '辽宁省朝阳果菜批发市场',
                     '辽宁阜新蔬菜农产品综合批发市场',
                     '辽宁鞍山宁远农产品批发市场',
                     '重庆观农贸批发市场',
                     '长春蔬菜中心批发市场',
                     '陕西咸阳市新阳光农副产品批发市场',
                     '陕西汉中过街楼蔬菜批发市场',
                     '陕西泾阳县云阳蔬菜批发市场',
                     '陕西西安朱雀农产品交易中心',
                     '青岛抚顺路蔬菜副食品批发市场',
                     '青岛黄河路农产品批发市场',
                     '青海省西宁市仁杰粮油批发市场',
                     '青海省西宁市海湖路蔬菜瓜果综合批发市场',
                     '黑龙江哈尔滨哈达果菜批发市场有限公司',
                     '黑龙江牡丹江市蔬菜批发市场',
                     '黑龙江鹤岗万圃源蔬菜批发市场',
                     '齐齐哈尔中心批发市场'
                    ]
    @market_id = nil
    @market_goods = []
    @prev_date = nil
  end

  def refresh_today
    get_pages(23, true)
    get_pages(24, true)
    get_pages(31, true)
    get_pages(22, true)
  end

  def refresh_all
    get_pages(23)
    get_pages(24)
    get_pages(31)
    get_pages(22)
  end

  #true 继续处理下一页 false 中断处理
  def get_one_page(class_id, url, only_resent)
    puts 'get_one_page ...'
    page = @agent.get(url)
    items = page.root.css('div.lmlist > ul > li')
    
    if class_id == 23
      x = lambda {|title| title.include?('今日行情动态') or title.include?('最新生猪价格走势') or title.include?('生猪价格行情')}
    elsif class_id == 24
      x = lambda {|title| title.include? ('全国各地仔猪价格')}
    elsif class_id == 31
      x = lambda {|title| title.include? '全国猪肉价格行情'}
    elsif class_id == 22
      x = lambda {|title| title.include? '各地种猪价格今日报价'}
    end
    
    return true if items.empty? 
    items.each do |item|
      date_text = item.css('span.time').text
      date = Date.parse "#{Time.now.year}-#{date_text[1..-2]}"
      #puts "date #{date}"
      if (@prev_date != nil) && (@prev_date != date) && only_resent
        return false                
      end
      aticle_link = item.css('a').select {|link| not link[:title].nil?}
      aticle_url = aticle_link[0][:href]
      title = aticle_link[0][:title]
      # puts "title: #{title}"
      if x.call(title)
         process_one_aticle(class_id, date, aticle_url)
         @prev_date = date
      end
    end
    return true
  end

  def process_one_aticle(class_id, date, url)
    puts 'process_one_aticle ...'
    page = @agent.get(url)
    process_sub_page(class_id, date, page)
    page.root.css('p[@align = "center"] b > a').each do |link|
      #pp link
      #puts "link #{link} link.text #{link.text}"
      link_text = link.text
      if ! link_text.include?('下一页')
        sub_page = @agent.get(link[:href])
        puts 'process_sub_page ...'
        process_sub_page(class_id, date, sub_page)
      end
    end
    SpiderHelper.save_one_day(@market_id, date, @market_goods, true, @common_goods)
  end

  def process_sub_page(class_id, date, page)
    #content = page.root.css('div.content')
    #items = content.xpath('.//*[not(*)]') #leaf element
    items = page.root.css('div.content > p')
    if class_id == 23
      key = '日 '
      category_name = '生猪'
      @common_goods = ['内三元', '外三元', '土杂猪']
    elsif class_id == 24
      key = '仔猪'
      category_name = '仔猪'
      @common_goods = ['仔猪10-15公斤', '仔猪15-20公斤', '仔猪20-30公斤']
    elsif class_id == 31
      key = '猪肉 白条'
      category_name = '禽肉'
      @common_goods = ['猪肉白条']
    elsif class_id == 22
      key = '种母猪'
      category_name = '种猪'
      @common_goods = ['二元母猪', '杜洛克母猪', '大白母猪', '长白母猪']
    end
    items.each do |item|      
      if item.text.include?(key)
        #handle br tag
        item.xpath('//br').each {|e| e.replace("\n")}
        #puts "item.text #{item.text}"
        item.text.split(/[\n]+/).map do |s|
          if s.strip != '' && s.strip != ' '
            data = extract_data(s, class_id)
            #pp data
            #puts s
            market = Market.find_or_create_by(name: data[:market_name])
            if ! market.nil?
              good = Goods.new
              good.name = data[:name]
              good.market_id = market.id
              good.date = date
              good.category_id = Category.find_by_name(category_name).id
              good.high = data[:price].to_d
              good.low = data[:price].to_d
              good.unit_id = SpiderHelper.get_unit_id(data[:unit_name])
              if (@market_id != nil) && (market.id != @market_id)
                #save to database
                SpiderHelper.save_one_day(@market_id, date, @market_goods, true, @common_goods)
                @market_goods = []              
              end
              #puts "insert good #{good}"
              #pp good
              @market_goods << good
              @market_id = market.id
            end
          end
        end
      end
    end
  end

  #23 #7月15日 山东省日照市 莒  县 生猪 内三元 11.80
  #23 #7月15日 山东省日照市 莒  县生猪土杂猪 12.60 
  #23 #7月15日 河北省唐山市 滦  县生猪 内三元 14.60 
  #23 #山东省德州市 陵  县 7月16日 生猪价格 外三元 14.00 
  #24 # 山东省德州市 陵  县 仔猪 15-20公斤   20
  #31 #猪肉 白条 20.40 青岛抚顺路蔬菜
  #31 #猪肉 白条 18.90 湖南长沙马王堆蔬菜
  #22 # 山东省日照市 莒  县 种母猪 二元母猪     1100元/吨
  #22 # 江苏省宿迁市 沭阳县 种母猪 二元母猪     1200
  def extract_data(s, class_id)
    #puts s
    r = {}
    if class_id == 23
      if s.include?('生猪价格')
        array = s.gsub(/ \s+/, '').gsub(/生猪价格/, ' 生猪 ').gsub(/ +/, ' ').split(' ')
      else
        array = s.gsub(/ \s+/, '').gsub(/生猪/, ' 生猪 ').gsub(/ +/, ' ').split(' ')
      end
      r[:category_name] = '生猪'
      if array[0].include?('日')
        r[:market_name] = array[1] + array[2]
      elsif array[2].include?('日')
        r[:market_name] = array[0] + array[1]
      end
      r[:name] = array[4]
      r[:price] = array[5].strip
      r[:unit_name] = '元/公斤'
    elsif class_id == 24
      array = s.gsub(/ \s+/, '').gsub(' ', ' ').strip.split(' ')
      r[:category_name] = '仔猪'
      r[:market_name] = array[0] + array[1]
      r[:name] = '仔猪'+array[3]
      r[:price] = array[4]
      r[:unit_name] = '元/公斤'
    elsif class_id == 31
      array = s.gsub(/ +/, ' ').split(' ')
      r[:category_name] = '禽肉'
      #由于显示的名称不完整，需要从一个查找表中查找完整的市场名称
      r[:market_name] = find_market_name(array[3])
      r[:name] = array[0] + array[1]
      r[:price] = array[2]
      r[:unit_name] = '元/公斤'
    elsif class_id == 22
      array = s.gsub(/ \s+/, '').gsub(/ +/, ' ').strip.split(' ')
      r[:category_name] = '种猪'
      r[:market_name] = array[0] + array[1]
      r[:name] = array[3]
      if array[4].include?('元/吨')
        r[:price] = array[4].scan(/\d+/)
        r[:unit_name] = array[4].scan(/\D+/)
      else
        r[:price] = array[4]
        r[:unit_name] = '元/吨'
      end
    end
    r
  end
  

  def find_market_name(s)
    @market_array.each do |market|
      if market.include?(s)
        return market
      end
    end
    puts "not find market: #{s}"
  end

  #class_id 23:生猪 24:仔猪 31:猪肉 22:种猪 
  def get_pages(class_id, only_resent = true)
    @prev_date = nil
    if (class_id == 23)
      puts "get_pages 生猪"
    elsif (class_id == 24)
      puts "get_pages 仔猪"
    elsif (class_id == 31)
      puts "get_pages 猪肉"
    elsif (class_id == 22)
      puts "get_pages 种猪"
    end

    url = "http://www.yz88.cn/news/ShowClass.asp?ClassID=#{class_id}&page=1"
    page_count = get_page_count(url)
    (1 .. page_count).each do |page_index|
      url = "http://www.yz88.cn/news/ShowClass.asp?ClassID=#{class_id}&page=#{page_index}"
      break if not get_one_page(class_id, url, only_resent)
    end
  end

  def get_page_count(url)
    page = @agent.get(url)
    last_page_link = page.root.css('div.showpage > a').select {|link| link.text.strip == '尾页'}
    page_count = last_page_link[0]["href"].split('page=', 2)[1].to_i
  end
end
