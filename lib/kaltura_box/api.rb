module KalturaBox
  class APIWrapper
    attr_accessor :client

    def initialize
      client = ::Kaltura::KalturaClientBase.new(KalturaBox.config)
    end
  end
end
