# -*- coding: utf-8 -*-
#import qiao_xi history data from file
require 'pp'

namespace :import_data do
  desc "Initial database"
  task :initial => :environment do
    # import category data
    import_category
    # import unit data
    import_unit
  end

  desc 'import name_category_dics' 
  task :import_name_category => :environment do
    import_name_category_dics
  end

  desc "Import data from  qiao_xi data"
  task :qiao_xi, [:path] => :environment do |t, args|    
    args.with_defaults(:path => "data/quote")
    puts "#{args.path} not exists" unless File.exists? args.path
    market_id = get_qiaoxi_market_id('石家庄桥西蔬菜中心批发市场')
    Dir.glob(File.join(args.path, '*.jason')) do |item|
      date = Date.parse(File.basename(item, '.jason'))
      if date > Date.parse('2013-01-01')
        File.open(item, 'r') do |f|
          quote_hash = parse_json(f.read)
          

          goods = quote_hash.inject([]) do |a, (key, value)|
            p1  = value['price_high']
            p2 = value['price_low']
            (p1 or p2) ? (a << Goods.new(:name => key, 
                                         :category_id => get_qiaoxi_category_id(key),
                                         :market_id => market_id,
                                         :date => date,
                                         :high => [p1, p2].reject {|v| v.nil?}.max,
                                         :low => [p1, p2].reject {|v| v.nil?}.min,
                                         :unit_id => get_qiaoxi_unit_id(key))) : a
          end
          #pp goods
          Goods.import goods
        end
      end
    end
  end

  desc "Import area and markets all in china"
  task :market, [:file] => :environment do |t, args|
    args.with_defaults(:file => "data/city_market.jason")
    puts "#{file} not exists" unless File.exists? args.file

    File.open(args.file, 'r') do |f|
      city_market_hash = parse_json(f.read)
      all_market = []
      area_id = 1
      market_id = 1

      areas = city_market_hash.map do |key, value|
        area = Area.new(:id => area_id,
                        :name => value['name'])
        if value['markets']
          value['markets'].each do |item|
            next if item.nil?
            market = Market.new(:id => market_id,
                                :name => item['name'], 
                                :area_id => area_id)
            market_id += 1
            all_market << market
          end

          if value['name'] == '河北省'
            #insert 石家庄桥西蔬菜中心批发市场
            a_market = Market.new(:id => market_id,
                                  :name => '石家庄桥西蔬菜中心批发市场',
                                  :area_id => area_id)
            market_id += 1
            all_market << a_market
          end

        end
        area_id += 1
        area
      end
      Area.import areas
      puts "import area finished"

      Market.import all_market
      puts "import market finished"
    end
  end

  def parse_json(json)
    JSON.parse(json) if json && json.length >= 2
  end

  def import_category
    array =  [
              {:id => 10, :name => '蔬菜'},
              {:id => 20, :name => '粮油'},
              {:id => 30, :name => '干鲜'},
              {:id => 40, :name => '水果'},
              {:id => 50, :name => '禽肉'},
              {:id => 60, :name => '水产'},

              {:id => 70, :name => '茶叶'},
              {:id => 80, :name => '种子'},
              {:id => 90, :name => '肥料'},
              {:id => 100, :name => '农药'},
              {:id => 110, :name => '兽药'},
              {:id => 120, :name => '燃油'},
              {:id => 130, :name => '饲料'},
              {:id => 140, :name => '种苗'},
              {:id => 150, :name => '地租'},
              {:id => 160, :name => '人工'}
             ]
    categories = array.inject([]) do  |list, item|
      category = Category.new
      category.id = item[:id]
      category.name = item[:name]
      list << category
    end
    Category.import categories
    puts "import categories finished"
  end

  def import_name_category_dics
    array = [ {:category_name => '蔬菜',
                :name_array =>
                ['长白菜', 
                 '圆白菜', 
                 '小白菜', 
                 '洋白菜', 
                 '甘兰', 
                 '菠菜', 
                 '油菜', 
                 '生菜', 
                 '香菜', 
                 '韭菜', 
                 '蒜苔', 
                 '新蒜苔', 
                 '蒜苗', 
                 '蒜黄', 
                 '茴香', 
                 '黄花菜', 
                 '毛豆', 
                 '油麦', 
                 '生笋', 
                 '大蒜', 
                 '新大蒜', 
                 '红薯', 
                 '麻山药', 
                 '胡萝卜', 
                 '白萝卜', 
                 '水萝卜', 
                 '樱桃萝卜',
                 '芹菜', 
                 '西芹', 
                 '藕', 
                 '茼蒿', 
                 '姜母', 
                 '生姜', 
                 '菜花', 
                 '青椒', 
                 '五彩椒', 
                 '尖椒', 
                 '红尖椒', 
                 '泡椒', 
                 '黄瓜', 
                 '茄子', 
                 '长茄子', 
                 '茄王', 
                 '土豆', 
                 '新土豆', 
                 '黄葱头', 
                 '红葱头', 
                 '西红柿', 
                 '樱桃柿', 
                 '四季豆', 
                 '豆王', 
                 '绿龙', 
                 '长豆角', 
                 '西葫芦', 
                 '西兰花', 
                 '香葱', 
                 '新大葱', 
                 '大葱', 
                 '鲜花生', 
                 '冬瓜', 
                 '本地冬瓜',
                 '南瓜', 
                 '北瓜', 
                 '金瓜', 
                 '苦瓜', 
                 '丝瓜', 
                 '荷兰瓜', 
                 '荷兰豆', 
                 '蘑菇', 
                 '鸡腿菇', 
                 '口蘑', 
                 '金针菇', 
                 '香菇', 
                 '瓠子', 
                 '娃娃菜', 
                 '香椿', 
                 '韭菜花', 
                 '大百合', 
                 '小百合', 
                 '玉米']
              },
              { :category_name => '粮油',
                :name_array =>
                ['标准粉',
                 '大米',
                 '富强粉',
                 '小米',
                 '玉米面',
                 '杂交米',
                 '挂面',
                 '黄豆',
                 '豆油',
                 '绿豆',
                 '卫生油',
                 '黑豆',
                 '调和油',
                 '红小豆',
                 '菜油',
                 '糯米',
                 '金龙鱼花生油',
                 '金龙鱼大豆油',
                 '鲁花花生油',
                 '福临门花生油']
              },
              { :category_name => '干鲜',
                :name_array =>
                ['大料',	 
                 '番茄酱',
                 '银耳',	 
                 '龙口粉丝', 
                 '香菇',	 
                 '花生米',
                 '莲花味精', 
                 '香油',	 
                 '花椒',	 
                 '白糖',	 
                 '珍极酱油', 
                 '红辣椒',
                 '珍极醋',
                 '小茴香',
                 '腐竹',
                 '黄花菜',
                 '槐茂面酱',
                 '海带',
                 '芥茉油',
                 '海带丝',
                 '十三香',
                 '紫菜',
                 '燕山酵母', 
                 '木耳', 
                 '鸡粉']
              },
              { :category_name => '水果',
                :name_array =>
                ['菠萝',
                 '精品青提',
                 '草莓',
                 '精品红提',
                 '葡萄',
                 '精品芒果',
                 '蟠桃',
                 '精品蛇果',
                 '桃',
                 '精品山竹',
                 '香蕉',
                 '精品脐橙',
                 '西瓜',
                 '精品香梨',
                 '鸭梨',
                 '精品毛丹',
                 '红橘',
                 '精品荔枝',
                 '杏',
                 '精品杨梅',
                 '柑橘',
                 '精品油桃',
                 '芦柑',
                 '进口香蕉',
                 '荔枝',
                 '精品布朗',
                 '甘蔗',
                 '精品水晶梨',
                 '水晶梨',
                 '精品猕猴桃',
                 '洋香瓜',
                 '精品火龙果',
                 '红富士',
                 '红星',
                 '国光苹果', 
                 '秦冠', 
                 '哈密瓜', 
                 '猕猴桃', 
                 '甜橙',
                 '巨峰葡萄', 
                 '李子',
                 '柿子',
                 '油桃',
                 '沙糖桔', 	 
                 '芒果', 	 
                 '美8号', 
                 '柚子', 
                 '樱桃', 
                 '石榴', 
                 '贡桔'] 
              },
              { :category_name => '禽肉',
                :name_array =>
                ['猪肉', 
                 '鸡蛋', 
                 '精瘦肉',	
                 '鸭蛋', 
                 '羊肉', 
                 '白条鸡',
                 '牛肉']
              },
              { :category_name => '水产',
                :name_array =>
                ['带鱼', 
                 '虾仁', 
                 '鲫鱼', 
                 '甜虾', 
                 '鲤鱼', 
                 '草鱼', 	
                 '鱿鱼', 
                 '鲢鱼', 
                 '对虾', 
                 '大黄花鱼']
              }
            ]
    name_categories = []

    array.each do | item|
      category_id = Category.find_by_name(item[:category_name]).id
      item[:name_array].each do |name| 
        name_category = NameCategoryDic.new
        name_category.name = name
        name_category.category_id = category_id
        name_categories << name_category
      end
    end

    NameCategoryDic.import name_categories
    puts "import name_categories finished"
  end

  def import_unit
    array = [{:id => 1, :name => '元/公斤'},
             {:id => 2, :name => '元/斤'},
             {:id => 3, :name => '元/克'},
             {:id => 4, :name => '元/两'},
             {:id => 5, :name => '元/件'},
             {:id => 6, :name => '元/桶'},
             {:id => 7, :name => '元/袋'},
             {:id => 8, :name => '元/盒'}
            ]
    units = array.inject([]) do |list, item|
      unit = Unit.new
      unit.id = item[:id]
      unit.name = item[:name]
      list << unit
    end
    Unit.import units
    puts "import units finished"
  end

  def get_qiaoxi_category_id(name)
    a = ['长白菜', 
         '圆白菜', 
         '小白菜', 
         '洋白菜', 
         '甘兰', 
         '菠菜', 
         '油菜', 
         '生菜', 
         '香菜', 
         '韭菜', 
         '蒜苔', 
         '新蒜苔', 
         '蒜苗', 
         '蒜黄', 
         '茴香', 
         '黄花菜', 
         '毛豆', 
         '油麦', 
         '生笋', 
         '大蒜', 
         '新大蒜', 
         '红薯', 
         '麻山药', 
         '胡萝卜', 
         '白萝卜', 
         '水萝卜', 
         '樱桃萝卜',
         '芹菜', 
         '西芹', 
         '藕', 
         '茼蒿', 
         '姜母', 
         '生姜', 
         '菜花', 
         '青椒', 
         '五彩椒', 
         '尖椒', 
         '红尖椒', 
         '泡椒', 
         '黄瓜', 
         '茄子', 
         '长茄子', 
         '茄王', 
         '土豆', 
         '新土豆', 
         '黄葱头', 
         '红葱头', 
         '西红柿', 
         '樱桃柿', 
         '四季豆', 
         '豆王', 
         '绿龙', 
         '长豆角', 
         '西葫芦', 
         '西兰花', 
         '香葱', 
         '新大葱', 
         '大葱', 
         '鲜花生', 
         '冬瓜', 
         '本地冬瓜',
         '南瓜', 
         '北瓜', 
         '金瓜', 
         '苦瓜', 
         '丝瓜', 
         '荷兰瓜', 
         '荷兰豆', 
         '蘑菇', 
         '鸡腿菇', 
         '口蘑', 
         '金针菇', 
         '香菇', 
         '瓠子', 
         '娃娃菜', 
         '香椿', 
         '韭菜花', 
         '大百合', 
         '小百合', 
         '玉米'] 

    b = ['标准粉',
         '大米',
         '富强粉',
         '小米',
         '玉米面',
         '杂交米',
         '挂面',
         '黄豆',
         '豆油',
         '绿豆',
         '卫生油',
         '黑豆',
         '调和油',
         '红小豆',
         '菜油',
         '糯米',
         '金龙鱼花生油',
         '金龙鱼大豆油',
         '鲁花花生油',
         '福临门花生油']

    c = ['大料',	 
         '番茄酱',
         '银耳',	 
         '龙口粉丝', 
         '香菇',	 
         '花生米',
         '莲花味精', 
         '香油',	 
         '花椒',	 
         '白糖',	 
         '珍极酱油', 
         '红辣椒',
         '珍极醋',
         '小茴香',
         '腐竹',
         '黄花菜',
         '槐茂面酱',
         '海带',
         '芥茉油',
         '海带丝',
         '十三香',
         '紫菜',
         '燕山酵母', 
         '木耳', 
         '鸡粉']

    d = ['菠萝',
         '精品青提',
         '草莓',
         '精品红提',
         '葡萄',
         '精品芒果',
         '蟠桃',
         '精品蛇果',
         '桃',
         '精品山竹',
         '香蕉',
         '精品脐橙',
         '西瓜',
         '精品香梨',
         '鸭梨',
         '精品毛丹',
         '红橘',
         '精品荔枝',
         '杏',
         '精品杨梅',
         '柑橘',
         '精品油桃',
         '芦柑',
         '进口香蕉',
         '荔枝',
         '精品布朗',
         '甘蔗',
         '精品水晶梨',
         '水晶梨',
         '精品猕猴桃',
         '洋香瓜',
         '精品火龙果',
         '红富士',
         '红星',
         '国光苹果', 
         '秦冠', 
         '哈密瓜', 
         '猕猴桃', 
         '甜橙',
         '巨峰葡萄', 
         '李子',
         '柿子',
         '油桃',
         '沙糖桔', 	 
         '芒果', 	 
         '美8号', 
         '柚子', 
         '樱桃', 
         '石榴', 
         '贡桔'] 

    e = ['猪肉', 
         '鸡蛋', 
         '精瘦肉',	
         '鸭蛋', 
         '羊肉', 
         '白条鸡',
         '牛肉']

    f = ['带鱼', 
         '虾仁', 
         '鲫鱼', 
         '甜虾', 
         '鲤鱼', 
         '草鱼', 	
         '鱿鱼', 
         '鲢鱼', 
         '对虾', 
         '大黄花鱼']
    

    if a.include?(name)
      return 10
    elsif b.include?(name)
      return 20
    elsif c.include?(name)
      return 30
    elsif d.include?(name)
      return 40
    elsif e.include?(name)
      return 50
    elsif f.include?(name)
      return 60
    else
      return 10
    end
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
      return 5
    elsif a6.include?(name)
      return 6
    elsif a7.include?(name)
      return 7
    elsif a8.include?(name)
      return 8
    else
      return 1
    end

    # if name.nil?
    #   return 1
    # elsif name.include?('克')
    #   return 3
    # elsif name.include?('两')
    #   return 4
    # elsif name.include?('件')
    #   return 5
    # elsif name.include?('桶')
    #   return 6
    # elsif name.include?('袋')
    #   return 7
    # elsif name.include?('盒')
    #   return 8
    # elsif name.include?('斤') && (not name.include?('公斤'))
    #   return 2
    # elsif name.include?('公斤')
    #   return 1
    # else 
    #   return 1
    # end
  end
end

