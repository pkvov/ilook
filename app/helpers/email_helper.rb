# -*- coding: utf-8 -*-
# Helper methods defined here can be accessed in any controller or view in the application

Ilook::App.helpers do
  # def simple_helper_method
  #  ...
  # end

  def self.verify_email_url(user)
    link_to "激活", :account, :verify, :key => ::Bcrypt::Password.create(user.email)    
  end
end
