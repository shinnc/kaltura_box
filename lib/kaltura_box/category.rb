require 'kaltura'
require 'kaltura_box/category/class_methods'
require 'kaltura_box/category/instance_methods'

module KalturaBox
  module Category

    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        include ClassMethods
        include InstanceMethods
      end
      super
    end

  end
end
