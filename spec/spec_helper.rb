$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'kaltura_box/api'
require 'kaltura_box/configuration'


module KalturaBoxTest
  def self.setup!
    KalturaBox.config do |c|
      c.login_email = 'user_email'
      c.login_password = 'password'
      c.partner_id = '1123123'
      c.subpartner_id = '1123123 * 100'
      c.administrator_secret = '694dec8e14bc48ee65dedb215fe688fc'
      c.user_secret = '081e5b61615ef172b6c8e301d9123f57'
      c.thumb_width = '300'
      c.thumb_height = '300'
      c.service_url = 'http://www.kaltura.com'
    end
  end
end
