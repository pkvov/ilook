# -*- coding: utf-8 -*-
# Defines our constants
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

##
# ## Enable devel logging
#
# Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#
# ## Configure your I18n
#
# I18n.default_locale = :en
I18n.default_locale = :zh_cn
#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

# load sidekiq worker
require File.join(PADRINO_ROOT, 'config', 'workers.rb')


##
# Add your before (RE)load hooks here
#
Padrino.before_load do
  require 'will_paginate'
  require 'will_paginate/active_record'
  require 'will_paginate/view_helpers/sinatra'
  include WillPaginate::Sinatra::Helpers
  ENV['BUNDLE_GEMFILE'] = "/home/kepeng/website/ilook/Gemfile"
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
  puts "add sidekiq activerecord suport"
  ::ActiveRecord::Base.send(:include, Sidekiq::Extensions::ActiveRecord)
  
  WeiboOAuth2::Config.api_key = "2472926561"
  WeiboOAuth2::Config.api_secret = "02c8a174871717b19ff19cc0ae3796ef"
  WeiboOAuth2::Config.redirect_uri = 'http://www.nongshangq.com/login/weibo'
end

Padrino.load!
