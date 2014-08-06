module KalturaBox
  module Entry
    module InstanceMethods

      def get
        client = KalturaBox::Client.update_session
        media = Kaltura::KalturaMediaService.new(client)
        media.get(self.entry_id)
      end

      def update_thumbnail(type=nil, value)
        self.add_thumbnail(self.entry_id, value, type)
      end

      def fetch_thumbnail
        kaltura_video = self.get
        unless kaltura_video.empty?
          self.thumbnail_url = kaltura_video.thumbnail_url
          self.save
        else
          false
        end
      end

    end
  end
end
