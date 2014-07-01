require 'kaltura'
require 'kaltura_box/client'
require 'active_record'

module KalturaBox
  module Entry
    module ClassMethods

      def upload(upload_object, options={})
        client = KalturaBox::Client.update_session
        media_entry = Kaltura::KalturaMediaEntry.new

        options.each do |key, value|
          media_entry.send("#{key}=", value) if valid_entry_attribute?(key)
        end

        media_entry.media_type = Kaltura::KalturaMediaType::VIDEO unless options[:media_type]

        if options[:source] == :file
          upload_token = client.media_service.upload(upload_object)
          client.media_service.add_from_uploaded_file(media_entry,upload_token).id
        end
      end

      def video_list
        client = KalturaBox::Client.update_session
        media = Kaltura::KalturaMediaService.new(client)
        media_list = media.list
        media_list.objects.reject { |v| v.media_type != 1  }
      end

      def update_all_videos!
        video_list.each do |v|
          self.create(
            entry_id: v.id,
            title: v.name,
            description: v.description,
            thumbnail_url: v.thumbnail_url,
            data_url: v.data_url,
            download_url: v.download_url,
            ms_duration: v.ms_duration,
            tags: v.tags,
            plays: v.plays,
            views: v.views
          )
        end
      end

    end
  end
end
