require 'kaltura'

module KalturaBox
  module Category
    module ClassMethods

      def list
        client = KalturaBox::Client.update_session
        category = Kaltura::KalturaCategoryService.new(client)
        category_list = category.list
        category_list.objects
      end

      def update_all_categories!
        list.each do |category|
          self.create(
            name: category.name,
            full_name: category.full_name,
            description: category.description,
            ref_id: category.id,
            entries_count: category.entries_count
          )
        end
      end

      def add(name, description, destroy_after_create = false)
        client = KalturaBox::Client.update_session
        category_svc = Kaltura::KalturaCategoryService.new(client)

        new_category = Kaltura::KalturaCategory.new
        new_category.name = name
        new_category.description = description

        if category = category_svc.add(new_category)
          @cat_obj = self.create(
            name: category.name,
            full_name: category.full_name,
            description: category.description,
            ref_id: category.id,
            entries_count: category.entries_count
          )
          category_svc.delete(@cat_obj.ref_id) if destroy_after_create
        end

        @cat_obj
      end

    end
  end
end
