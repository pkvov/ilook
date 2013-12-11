# Helper methods defined here can be accessed in any controller or view in the application

Ilook::App.helpers do
  # def simple_helper_method
  #  ...
  # end

  @@o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  def random_string()
    (0...50).map{ @@o[rand(@@o.length)] }.join
  end
end
