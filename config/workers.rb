Dir[File.expand_path('../../workers/*.rb', __FILE__)].each{|file| 
  puts file  
  require file
}
