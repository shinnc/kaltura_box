require 'kaltura'
require 'kaltura_box/client'
require 'active_record'

module KalturaBox
  module Entry
    module ClassMethods

      def video_list
        KalturaBox::Client.update_session
        client = KalturaBox::Client.create
        media = Kaltura::KalturaMediaService.new(client)
        media_list = media.list
        media_list.to_params["objects"].reject { |v| v.media_type != 1  }
      end

      def update_all_videos!
        video_list.each do |v|
          self.create(entry_id: v.id)
        end
      end

    end
  end
end
