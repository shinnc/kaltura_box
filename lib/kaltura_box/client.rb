require 'kaltura'
require 'kaltura_box/configuration'

module KalturaBox
  class Client
    attr_accessor :client, :client_config, :session_key

    class << self

      def create
        self.setup_config unless @client_config
        @client = Kaltura::KalturaClient.new(@client_config)
        @client.ks = @session_key
        @client
      end

      def setup_config
        raise "Missing Partner Identifier" unless KalturaBox.config.partner_id
        @client_config = Kaltura::KalturaConfiguration.new(KalturaBox.config.partner_id)
        @client_config.service_url = KalturaBox.config.service_url

        self.generate_session_key

        @client_config
      end

      def generate_session_key
        self.update_session

        raise "Missing Administrator Secret" unless KalturaBox.config.administrator_secret
        begin
          @session_key = @client.session_service.start(KalturaBox.config.administrator_secret, '', Kaltura::KalturaSessionType::ADMIN, KalturaBox.config.partner_id, 315360000)
        rescue Kaltura::KalturaAPIError => e
          puts e.message
        end
      end

      def update_session
        @client ? @client : self.create
      end

    end

  end
end
