require 'spec_helper'
require 'active_record'

class Video < ActiveRecord::Base
  include KalturaBox::Entry
end

describe "KalturaBox::Entry" do

  before(:each) { KalturaBoxTest.setup! }

  describe "instance methods" do

    context "list" do
      it "to return KalturaMediaListResponse" do
        expect(Video.list.class).to eq Kaltura::KalturaMediaListResponse
      end
    end

  end

end
