require 'kaltura'

module KalturaBox
  module Category
    module InstanceMethods

      def edit(options={})
        client = KalturaBox::Client.update_session
        category_svc = Kaltura::KalturaCategoryService.new(client)

        category = Kaltura::KalturaCategory.new
        category.name = options[:name]
        category.description = options[:description]

        if category = category_svc.update(self.ref_id, category)
          self.update(name: category.name, description: category.description)
        end
      end

      def remove
        client = KalturaBox::Client.update_session
        category_svc = Kaltura::KalturaCategoryService.new(client)

        result = category_svc.delete(self.ref_id) # should returns nil
        self.destroy
      end

    end
  end
end
