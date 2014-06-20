require 'kaltura_box/entry/class_methods'
require 'kaltura_box/entry/instance_methods'
require 'kaltura_box/entry/metadata'

module KalturaBox
  module Entry

    #
    # Entry object should have the following attributes:
    # entry_id

    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        include Metadata
        include InstanceMethods
        include ClassMethods
      end
      super
    end

  end
end
