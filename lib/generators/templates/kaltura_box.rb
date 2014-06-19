# Set up the following configuration with environment variables (Recommended)
#
# Obtain your Kaltura API publisher credentials via the KMC Integration Settings
# http://www.kaltura.com/index.php/kmc/kmc4#account|integration
#

KalturaBox.config do |c|
  c.login_email = ENV["USER_EMAIL"]
  c.login_password = ENV["THE_PASSWORD"]
  c.partner_id = ENV["PARTNER_ID"]
  c.subpartner_id = ENV["PARTNER_ID"].to_i * 100
  c.administrator_secret = ENV["ADMINISTRATOR_SECRET"]
  c.user_secret = ENV["USER_SECRET"]
  c.thumb_width = "300"
  c.thumb_height = "300"
  c.player_conf_id = ENV["whatever"]
  c.service_url = "http://www.kaltura.com"
end
