# -*- coding: utf-8 -*-
# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#
email     = shell.ask "Which email do you want use for logging into admin?"
password  = shell.ask "Tell me the password to use:"

shell.say ""

account = Account.create(:email => email, :name => "Foo", :surname => "Bar", :password => password, :password_confirmation => password, :role => "admin")

if account.valid?
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email: #{email}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went wrong!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""

shell.say "import category"
Category.create!(:name => "蔬菜")
Category.create!(:name => '粮油')
Category.create!(:name => '干鲜')
Category.create!(:name => '水果')
Category.create!(:name => '禽肉')
Category.create!(:name => '水产')
Category.create!(:name => '生猪')
Category.create!(:name => '仔猪')
Category.create!(:name => '种猪')

# Category.create!(:name => '茶叶')
# Category.create!(:name => '种子')
# Category.create!(:name => '肥料')
# Category.create!(:name => '农药')
# Category.create!(:name => '兽药')
# Category.create!(:name => '燃油')
# Category.create!(:name => '饲料')
# Category.create!(:name => '种苗')
# Category.create!(:name => '地租')
# Category.create!(:name => '人工')

shell.say "import unit"
Unit.create!(:name => '元/公斤')
Unit.create!(:name => '元/斤')
Unit.create!(:name => '元/克')
Unit.create!(:name => '元/两')
Unit.create!(:name => '元/件')
Unit.create!(:name => '元/桶')
Unit.create!(:name => '元/袋')
Unit.create!(:name => '元/盒')
Unit.create!(:name => '元/吨')

shell.say "import name_category_dics"

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
             '鸡粉',
             '干香菇']
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

array.each do | item|
  category_id = Category.find_by_name(item[:category_name]).id
  item[:name_array].each do |name| 
    NameCategoryDic.create!(:name => name,
                            :category_id  => category_id)
  end
end

shell.say "import area and markets"
path = File.join(Padrino.root, "db", 'area_market.json')
File.open(path, 'r') do |f|
  city_market_hash = parse_json(f.read)
  all_market = []
  area_id = 1
  market_id = 1

  city_market_hash.map do |key, value|
    area = Area.create!(:id => area_id,
                    :name => value['name'])
    if value['markets']
      value['markets'].each do |item|
        next if item.nil?
        market = Market.create!(:id => market_id,
                            :name => item['name'], 
                            :area_id => area_id)
        market_id += 1
      end

      if value['name'] == '河北省'
        #insert 石家庄桥西蔬菜中心批发市场
        a_market = Market.create!(:id => market_id,
                              :name => '石家庄桥西蔬菜中心批发市场',
                              :area_id => area_id)
        market_id += 1
      end
    end

    area_id += 1
  end
end


def parse_json(json)
  JSON.parse(json) if json && json.length >= 2
end

