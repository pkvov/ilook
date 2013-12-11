source 'https://rubygems.org'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'

# Component requirements
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'will_paginate', '~>3.0'
gem 'sass'
gem 'haml'
#gem 'activerecord', '>= 3.1', :require => 'active_record'
gem 'activerecord', '3.2.15', :require => 'active_record'
gem 'sqlite3'

# Test requirements
gem 'shoulda', :group => 'test'
gem 'rack-test', :require => 'rack/test', :group => 'test'

gem 'tilt', '1.3.7'

#gem 'json', '~> 1.7.7'

# Padrino Stable Gem
gem 'padrino', '0.11.1'
#gem 'padrino', '0.11.2'


# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.11.1'
# end

#import large data for activerecord
gem 'activerecord-import'

#background work use sidekiq
gem 'sidekiq', :git => 'git://github.com/dariocravero/sidekiq.git', :branch => 'padrino'

#spider the web
gem 'mechanize'

#clockwork
gem 'clockwork'

gem 'gruff'
gem 'rmagick'

#mysql adapter
gem "mysql2", "~> 0.3.12b4"

#fix Invalid byte sequence in US-ASCII (ArgumentError)  
#https://github.com/padrino/padrino-framework/issues/1263
#/var/lib/gems/1.9.1/gems/http_router-0.11.0/lib/http_router/
# class HttpRouter::Request
#     def initialize(path, rack_request)
#       @rack_request = rack_request
#       @path = Rack::Utils.unescape(path).split(/\//)
#       @path.shift if @path.first == ''
#       @path.push('') if path[-1] == ?/
#       @extra_env = {}
#       @params = []
#       @acceptable_methods = Set.new
#     end
# end

# weibo open api
gem 'weibo_2'

#add search egine
gem 'thinking-sphinx', '~> 3.0.2',
  :require => 'thinking_sphinx/sinatra'

#add a state machine
#gem 'state_machine'

gem 'unicorn'

gem 'slim'