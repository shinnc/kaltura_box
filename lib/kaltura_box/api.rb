require 'kaltura'

module KalturaBox
  class APIWrapper
    attr_accessor :client

    def initialize
      self.client = ::Kaltura::KalturaClientBase.new(KalturaBox.config)
    end

  end
end
