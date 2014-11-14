require 'kaltura'
require 'kaltura_box/api'
require 'kaltura_box/category'
require 'kaltura_box/client'
require 'kaltura_box/entry'
require 'kaltura_box/version'

module KalturaBox
  require 'kaltura_box/railtie' if defined?(Rails) &&
                                   Rails.version.split('.').first > '2'
end
