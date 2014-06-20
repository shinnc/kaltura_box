require 'spec_helper'

describe "KalturaBox::APIWrapper" do
  let(:api) { KalturaBox::APIWrapper.new }

  before(:all) { KalturaBoxTest.setup! }

  describe "config values" do
    it { expect( api.client.config.login_email ).to eq(KalturaBox.config.login_email) }
    it { expect( api.client.config.login_password ).to eq(KalturaBox.config.login_password) }
    it { expect( api.client.config.partner_id ).to eq(KalturaBox.config.partner_id) }
    it { expect( api.client.config.subpartner_id ).to eq(KalturaBox.config.subpartner_id) }
    it { expect( api.client.config.administrator_secret ).to eq(KalturaBox.config.administrator_secret) }
    it { expect( api.client.config.user_secret ).to eq(KalturaBox.config.user_secret) }
    it { expect( api.client.config.thumb_width ).to eq(KalturaBox.config.thumb_width) }
    it { expect( api.client.config.thumb_height ).to eq(KalturaBox.config.thumb_height) }
    it { expect( api.client.config.player_conf_id ).to eq(KalturaBox.config.player_conf_id) }
    it { expect( api.client.config.service_url ).to eq(KalturaBox.config.service_url) }
    it { expect( api.client.config.logger ).to eq(KalturaBox.config.logger) }
  end

end
