require 'spec_helper'
require 'active_record'

class Video < ActiveRecord::Base
  include KalturaBox::Entry
end

describe "KalturaBox::Entry" do

  before(:each) { KalturaBoxTest.setup! }

  describe "instance methods" do

    context "list" do

      before(:each) { KalturaBoxTest.setup_db! }

      it "to return an Array" do
        zxc = Video.update_all_videos!
        expect(zxc.class).to eq Array
      end
    end

  end

end
