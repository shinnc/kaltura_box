require 'kaltura'
require 'kaltura_box/configuration'

module KalturaBox
  class Client
    attr_accessor :client, :client_config, :session_key

    class << self

      def create
        self.setup_config unless @client_config
        @client = Kaltura::KalturaClientBase.new(@client_config)
      end

      def setup_config
        raise "Missing Partner Identifier" unless KalturaBox.config.partner_id
        @client_config = Kaltura::KalturaConfiguration.new(KalturaBox.config.partner_id)
        @client_config.service_url = KalturaBox.config.service_url

        @client_config
      end

      def generate_session_key
        self.update_session

        raise "Missing Administrator Secret" unless KalturaBox.config.administrator_secret
        begin
          @session_key = @client.session_service.start(KalturaBox.config.administrator_secret, '', Kaltura::KalturaSessionType::ADMIN)
          @client.ks = @session_key
        rescue Kaltura::APIError => e
          puts e.message
        end
      end

      def update_session
        if @client
          true
        else
          self.create
          true
        end
      end

    end

  end
end
