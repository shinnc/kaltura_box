$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'kaltura_box'

module KalturaBoxTest
  def self.setup!
    KalturaBox.config do |c|
      c.login_email = 'shinn@tinkerbox.com.sg'
      c.login_password = 'enCdU64oGJQU+V'
      c.partner_id = '1761822'
      c.subpartner_id = '176182200'
      c.administrator_secret = '694dec8e14bc48ee65dedb215fe655fc'
      c.user_secret = '081e5b61615ef172b6c8e301d9712f57'
      c.thumb_width = '300'
      c.thumb_height = '300'
      c.player_conf_id = '24691582'
      c.service_url = 'http://www.kaltura.com'
    end
  end

  def self.setup_db!
    ActiveRecord::Base.logger = Logger.new(STDERR)
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: ":memory:"
    )

    migration = Class.new(ActiveRecord::Migration) do

      def change
        create_table :videos, :force => true do |t|
          t.string :entry_id
          t.string :title
          t.string :description
          t.string :thumbnail_url
          t.string :data_url
          t.string :download_url
          t.string :ms_duration
          t.string :tags
          t.string :plays
          t.string :views

          t.timestamps
        end
      end

    end

    migration.new.migrate(:up)
  end
end
