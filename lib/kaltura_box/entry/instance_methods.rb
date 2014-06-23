module KalturaBox
  module Entry
    module InstanceMethods

      def get
        KalturaBox::Client.update_session
        client = KalturaBox::Client.create
        media = Kaltura::KalturaMediaService.new(client)
        media.get(self.entry_id)
      end

    end
  end
end
