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

      describe "searching" do

        context "valid search" do
          it "returns an array" do
            expect(Video.video_list("education").class).to eq Array
          end
        end

        context "invalid search" do
          it "returns nil" do
            expect(Video.video_list("blabla")).to be_nil
          end
        end

      end

    end

    context "update all videos" do
      before(:each) do
        KalturaBoxTest.setup_db!
        Video.update_all_videos!(company_id: 5)
      end

      it { expect(Video.count).to eq videos.count }
      it { expect(Video.last.company_id).to eq 5 }
    end

  end

  describe "instance methods" do
    before(:all) { KalturaBoxTest.setup_db! }

    let(:video) { Video.new(entry_id: "0_7ivwzhbh") }

    context "get" do
      it { expect(video.get.id).to eq "0_7ivwzhbh" }
    end

  end

end
