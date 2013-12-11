require 'gruff'
require 'date'

class TrendGraph
  def initialize
    @path = File.join(Padrino.root, 'public', 'images', 'trend')
    FileUtils.makedirs(@path) unless File.exists?(@path)
  end

  def generate
    market_name_set = Goods.select('market_id, name').group('market_id, name')
    market_name_set.each do |item|
      market_id = item[:market_id]
      name = item[:name]
      #puts "market_id #{market_id}, name #{name}"
      generate_one(market_id, name)
    end
  end

  def generate_one(market_id, name)
    date = (DateTime.now - 90).strftime("%Y-%m-%d")
    goods = Goods.where("market_id = #{market_id} and name = '#{name}' and date > '#{date}'").order('date asc')
    g = Gruff::Line.new
    g.title = "trend"
    high_array = []
    low_array = []
    date_hash = {}
    index = 0
    goods.each do |good|
      high_array << good[:high]
      low_array << good[:low]
      if good[:date].wday == 0
        date_hash[index] = good[:date].strftime("%m/%d")
      end
      index += 1
    end
    
    g.data("high", high_array)
    g.data("low", low_array)
    g.labels = date_hash
    g.write(File.join(@path, "#{market_id}.#{name}.png"))
  end

end
