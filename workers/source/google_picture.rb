# -*- coding: utf-8 -*-
# scrap the picture by name

require 'mechanize'
#require 'iconv'
require 'pp'

class GooglePicture

  def initialize()
    @path = File.join(Padrino.root, 'public')
    @agent = Mechanize.new
    @agent.read_timeout = 1
    #@agent.set_proxy 'localhost', 8087
    @agent.pre_connect_hooks << lambda do |agent, request|
      sleep 1
    end
  end

  def start
    if @goods.nil?
      @goods = Goods.uniq.pluck(:name)
    end

    @goods.each do |name|
      google_pic(name)
    end
  end

  def google_pic(name)
    # google the picture by name and save the path
    path = File.join(@path, "images", "logo", "#{name}.jpg")
    return if File.exists?(path)
    
    puts "try to google #{path}"
    page = @agent.get("https://www.google.com.tw/imghp?hl=zh-CN&tab=wi")
    page.encoding = 'utf-8'
    search_form = page.form_with(:name => 'f')
    search_form.field_with(:name => "q").value = name
    search_results = @agent.submit(search_form)
    dir = File.dirname(path)
    FileUtils.makedirs(dir) unless File.exists?(dir)
    images = search_results.root.css('//a > img')
    images.each { |image| 
      #save first image file
      img_src = image["src"]
      puts img_src
      begin
        @agent.get(img_src).save_as(path)
        puts "save to path: #{path}"
        return
      rescue => error
        puts error
      end
    }
  end
  
end
