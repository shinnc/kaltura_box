module KalturaBox
  module Entry
    module InstanceMethods

      def get
        client = KalturaBox::Client.update_session
        media = Kaltura::KalturaMediaService.new(client)
        media.get(self.entry_id)
      end

    end
  end
end
