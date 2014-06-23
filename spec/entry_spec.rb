require 'spec_helper'
require 'active_record'

class Video < ActiveRecord::Base
  include KalturaBox::Entry
end

describe "KalturaBox::Entry" do

  before(:each) { KalturaBoxTest.setup! }

  describe "class methods" do

    let(:videos) { Video.video_list }

    context "video_list" do
      it { expect(videos.class).to eq Array }
    end

    context "update all videos" do
      before(:each) { KalturaBoxTest.setup_db! }
      it { expect{Video.update_all_videos!}.to change{Video.count}.from(0).to(videos.count) }
    end

  end

  describe "instance methods" do

  end

end
