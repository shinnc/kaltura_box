require 'kaltura'
require 'kaltura_box/client'

module KalturaBox
  module Entry
    module ClassMethods

      def list
        KalturaBox::Client.update_session
        client = KalturaBox::Client.create
        media = Kaltura::KalturaMediaService.new(client)
        media.list
      end

    end
  end
end
