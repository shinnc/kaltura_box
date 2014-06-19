require "kaltura_box/version"

module KalturaBox
  require 'kaltura_fu/railtie' if defined?(Rails) && Rails.version.split(".").first > "2"
end
