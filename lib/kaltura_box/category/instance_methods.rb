require 'kaltura'

module KalturaBox
  module Category
    module InstanceMethods
      # def update
      #   client = KalturaBox::Client.update_session
      # end
      def remove
        client = KalturaBox::Client.update_session
        category_svc = Kaltura::KalturaCategoryService.new(client)
        category_svc.delete(self.ref_id)
        self.destroy
      end
    end
  end
end
