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

      def add_thumbnail(entry_id, value, type=nil)
        client = KalturaBox::Client.update_session
        media_service = Kaltura::KalturaMediaService.new(client)
        media = nil

        case type
        when :jpg
          media = media_service.update_thumbnail_jpeg(entry_id, value)
        when :url
          media = media_service.update_thumbnail_from_url(entry_id, value)
        else
          media = media_service.update_thumbnail(entry_id, value)
        end
        media.thumbnail_url
      end

      def video_list(keyword = nil)
        client = KalturaBox::Client.update_session
        media = Kaltura::KalturaMediaService.new(client)

        if keyword
          filter = Kaltura::KalturaBaseEntryFilter.new
          filter.free_text = keyword
          media_list = media.list(filter)
        else
          media_list = media.list
        end

        return nil unless media_list.present? && media_list.objects

        media_list.objects.reject { |v| v.media_type != 1  }
      end

      def update_all_videos!(company_id = nil)
        video_list.each do |v|
          entry = self.new(
            entry_id: v.id,
            title: v.name,
            description: v.description,
            thumbnail_url: v.thumbnail_url,
            data_url: v.data_url,
            download_url: v.download_url,
            ms_duration: v.ms_duration,
            plays: v.plays,
            views: v.views,
            company_id: company_id
          )
          entry.tag_list = v.tags
          entry.save
        end
      end

    end
  end
end
