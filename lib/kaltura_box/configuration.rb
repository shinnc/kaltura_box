require 'singleton'

module KalturaBox
  class Config
    include Singleton

    ATTRIBUTES = [ :login_email, :login_password, :partner_id, :subpartner_id,
      :administrator_secret, :user_secret, :thumb_width, :thumb_height,
      :player_conf_id, :service_url, :logger ]

    attr_accessor *ATTRIBUTES
  end

  def self.config
    if block_given?
      yield Config.instance
    else
      Config.instance
    end
  end

end
