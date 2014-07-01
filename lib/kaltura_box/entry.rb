require 'kaltura_box/entry/class_methods'
require 'kaltura_box/entry/instance_methods'
require 'kaltura_box/entry/metadata'

module KalturaBox
  module Entry

    #
    # Entry object should have the following attributes:
    #
    # entry_id
    # title
    # description
    # title
    # description
    # thumbnail_url
    # data_url
    # download_url
    # ms_duration
    # tags
    # plays
    # views
    #

    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        include InstanceMethods
        include ClassMethods
        include Metadata
      end
      super
    end

  end
end
