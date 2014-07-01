require 'spec_helper'

class Video < ActiveRecord::Base
  include KalturaBox::Entry
end

describe "KalturaBox::Entry::Metadata" do

  before(:each) { KalturaBoxTest.setup! }
  before(:all) { KalturaBoxTest.setup_db! }

  describe "getter/setter methods" do

    it "should respond to getting valid entry attributes" do
      test = Video.new
      expect(test).to respond_to :get_name
    end

    it "should respond to getting valid entry attributes" do
      test = Video.new
      expect(test).to respond_to :get_description
    end

    it "should respond to getting valid entry attributes" do
      test = Video.new
      expect(test).to respond_to :get_categories
    end

    it "should respond to setting valid entry attributes" do
      test = Video.new
      expect(test).to respond_to :set_description
    end

    it "should respond to setting valid entry attributes" do
      test = Video.new
      expect(test).to respond_to :set_name
    end

    it "should respond to setting valid entry attributes" do
      test = Video.new
      expect(test).to respond_to :set_categories
    end

    it "should respond to adding valid entry attributes" do
      test = Video.new
      expect(test).to respond_to :add_categories
    end

    it "should respond to adding valid entry attributes" do
      test = Video.new
      expect(test).to respond_to :add_tags
    end

    it "should respond to adding valid entry attributes" do
      test = Video.new
      expect(test).to respond_to :add_admin_tags
    end

    it "should not respond to getting invalid entry attributes" do
      test = Video.new
      expect(test).to_not respond_to :get_barack_obama
    end

    it "should not respond to setting invalid entry attributes" do
      test = Video.new
      expect(test).to_not respond_to :set_magic
    end

    it "should not respond to adding invalid entry attributes" do
      test = Video.new
      expect(test).to_not respond_to :add_waffles
    end

    it "should not respond to adding invalid entry attributes" do
      test = Video.new
      expect(test).to_not respond_to :add_category
    end

    it "should not respond to adding invalid entry attributes" do
      test = Video.new
      expect(test).to_not respond_to :add_tag
    end

    it "should not respond to adding invalid entry attributes" do
      test = Video.new
      expect(test).to_not respond_to :add_admin_tag
    end

    it "should not respond to adding valid entry attributes, but improperly typed" do
      test = Video.new
      expect(test).to_not respond_to :add_name
    end

    it "should not respond to adding valid entry attributes, but improperly typed" do
      test = Video.new
      expect(test).to_not respond_to :add_names
    end

  end

  describe "methods with @entry_id" do

    let(:test_video) { Video.new(entry_id: @entry_id) }

    before(:each) { @entry_id = Video.upload(KalturaBoxTest.sample_video, source: :file) }

    it "should set the name field when asked kindly" do
      expect(test_video.set_name("waffles")).to eq "waffles"
    end

    it "should set the desription field when asked kindly" do
      expect(test_video.set_description("The beginning of the end of the beginning")).to eq "The beginning of the end of the beginning"
    end

    it "should be a little weirder when setting a group of tags" do
      expect(test_video.set_tags("waffles,awesome,rock,hard")).to eq "waffles, awesome, rock, hard"
      expect(test_video.get_tags).to eq "waffles, awesome, rock, hard"
    end

    it "should just be weird with tags, admin tags don't act this way either" do
      expect(test_video.set_admin_tags("waffles,awesome,rock,hard")).to eq "waffles,awesome,rock,hard"
      expect(test_video.get_admin_tags).to eq "waffles,awesome,rock,hard"
    end

    it "shouldn't act like tags with categories" do
      expect(test_video.set_categories("waffles,awesome,rock,hard")).to eq "waffles,awesome,rock,hard"
    end

    it "should raise a Kaltura::APIError when you give it a bogus entry" do
      test = Video.new(entry_id: "waffles")
      expect { test.set_name("waffles") }.to raise_error(Kaltura::KalturaAPIError)
    end

    it "should not increment the version when you perform set actions" do
      version_count = test_video.get_version.to_i

      test_video.set_name("my new name")
      expect(test_video.get_version.to_i).to eq version_count
    end

    it "should not increment the version when you perform set actions on tags" do
      version_count = test_video.get_version.to_i

      test_video.set_tags("buttons,kittens,pirates")
      expect(test_video.get_version.to_i).to eq version_count
    end

    xit "should be making KMC categories for every category you set unless it already exists." do
      categories = "waffles#{rand(10)},pirates#{rand(18)},peanuts#{rand(44)}"
      categories.split(",").each do |category|
        expect(test_video.category_exists?(category)).to be_false
      end

      test_video.set_categories(categories)

      categories.split(",").each do |category|
        cat = test_video.category_exists?(category)
        expect(cat).to be_false
      end

      bob = KalturaBox.client.category_service.list.objects
      bob.each do |cat|
        if cat.name =~/^(waffles|pirates|peanuts)(.*)/
          KalturaBox.client.category_service.delete(cat.id)
        end
      end

    end

    it "should allow you to add tags onto an existing tag string without knowing the original tags" do
      original_tags = test_video.set_tags("gorillaz, pop, damon, albarn")

      expect(test_video.add_tags("mos,def")).to eq original_tags + ", mos, def"
    end

    it "no longer responds to adding a single tag.  dynamic dispatches are cooler than syntax sugar." do
      original_tags = test_video.set_tags("gorillaz, pop, damon, albarn")

      expect{test_video.add_tag("mos")}.to raise_error
    end

    it "should allow you to add admin tags onto an existing tag string without knowing the original tags" do
      original_tags = test_video.set_admin_tags("gorillaz,pop,damon,albarn")

      expect(test_video.add_admin_tags("mos,def")).to eq original_tags + ",mos,def"
    end

    it "no longer responds to adding a single admin tag" do
      original_tags = test_video.set_admin_tags("gorillaz, pop, damon, albarn")

      expect{test_video.add_admin_tag("mos")}.to raise_error
    end

    xit "should let you add categories onto an existing category string as well." do
      original_categories = test_video.set_categories("peanuts#{rand(10)}")

      new_cats = "pirates#{rand(10)},waffles#{rand(10)}"
      expect(test_video.add_categories(new_cats)).to eq original_categories + ",#{new_cats}"
      check_string = original_categories + ",#{new_cats}"
      check_string.split(",").each do |category|
        cat = test_video.category_exists?(category)
        expect(cat).to_not be_false
      end
      bob = KalturaBox.client.category_service.list.objects
      bob.each do |cat|
        if cat.name =~/^(waffles|pirates|peanuts)(.*)/
          KalturaBox.client.category_service.delete(cat.id)
        end
      end
    end

    xit "should create categories for each one you add if they don't exist." do
      original_categories = test_video.set_categories("peanuts#{rand(10)}")

      new_cats = "pirates#{rand(10)},waffles#{rand(10)}"
      test_video.add_categories(new_cats)
      check_string = original_categories + ",#{new_cats}"
      check_string.split(",").each do |category|
        cat = test_video.category_exists?(category)
        expect(cat).to_not be_false
      end
      bob = KalturaBox.client.category_service.list.objects
      bob.each do |cat|
        if cat.name =~/^(waffles|pirates|peanuts)(.*)/
          KalturaBox.client.category_service.delete(cat.id)
        end
      end
    end

    xit "should no longer respond to adding a single category" do
      original_categories = test_video.set_categories("peanuts#{rand(10)},pirates#{rand(10)}")

      new_cat = "waffles#{rand(10)}"
      expect{test_video.add_category(new_cat)}.to raise_error

      bob = KalturaBox.client.category_service.list.objects
      bob.each do |cat|
        if cat.name =~/^(waffles|pirates|peanuts)(.*)/
          KalturaBox.client.category_service.delete(cat.id)
        end
      end
    end

    it "should let you set multiple fields at once with set()" do
      name = "Mr Peanut's wild ride"
      description = "Man this is a random name"
      waffles = "Man waffles isn't an attribute"
      test_video.set(@entry_id, :name=>name,:description=>description,:waffles=>waffles)

      expect(test_video.get_name).to eq name
      expect(test_video.get_description).to eq description
    end

  end

end
