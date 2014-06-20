require 'kaltura'
require 'kaltura_box/client'

module KalturaBox
  module Entry
    module ClassMethods

      # def upload(ojb, options={})
      # end

      def list
        ::KalturaBox::Client.update_session
        client = KalturaBox::Client.create
        client.queue_service_action_call("media", "list")
      end

    end
  end
end
