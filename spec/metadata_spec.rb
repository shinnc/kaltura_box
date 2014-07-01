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

    before(:each) { @entry_id = Video.upload(KalturaBoxTest.sample_video, source: :file) }

    it "should set the name field when asked kindly" do
      test = Video.new
      expect(test.set_name(@entry_id,"waffles")).to eq "waffles"
    end

    it "should set the desription field when asked kindly" do
      test = Video.new
      expect(test.set_description(@entry_id,"The beginning of the end of the beginning")).to eq "The beginning of the end of the beginning"
    end

    it "should be a little weirder when setting a group of tags" do
      test = Video.new
      expect(test.set_tags(@entry_id,"waffles,awesome,rock,hard")).to eq "waffles, awesome, rock, hard"
      expect(test.get_tags(@entry_id)).to eq "waffles, awesome, rock, hard"
    end

    it "should just be weird with tags, admin tags don't act this way either" do
      test = Video.new
      expect(test.set_admin_tags(@entry_id,"waffles,awesome,rock,hard")).to eq "waffles,awesome,rock,hard"
      expect(test.get_admin_tags(@entry_id)).to eq "waffles,awesome,rock,hard"
    end

    it "shouldn't act like tags with categories" do
      test = Video.new
      expect(test.set_categories(@entry_id,"waffles,awesome,rock,hard")).to eq "waffles,awesome,rock,hard"
    end

    it "should raise a Kaltura::APIError when you give it a bogus entry" do
      test = Video.new

      expect { test.set_name("waffles","waffles") }.to raise_error(Kaltura::KalturaAPIError)
    end

    it "should not increment the version when you perform set actions" do
      test = Video.new

      version_count = test.get_version(@entry_id).to_i

      test.set_name(@entry_id,"my new name")
      expect(test.get_version(@entry_id).to_i).to eq version_count
    end

    it "should not increment the version when you perform set actions on tags" do
      test = Video.new

      version_count = test.get_version(@entry_id).to_i

      test.set_tags(@entry_id,"buttons,kittens,pirates")
      expect(test.get_version(@entry_id).to_i).to eq version_count
    end

    xit "should be making KMC categories for every category you set unless it already exists." do
      test = Video.new

      categories = "waffles#{rand(10)},pirates#{rand(18)},peanuts#{rand(44)}"
      categories.split(",").each do |category|
        expect(test.category_exists?(category)).to be_false
      end

      test.set_categories(@entry_id,categories)

      categories.split(",").each do |category|
        cat = test.category_exists?(category)
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
      test = Video.new

      original_tags = test.set_tags(@entry_id,"gorillaz, pop, damon, albarn")

      expect(test.add_tags(@entry_id,"mos,def")).to eq original_tags + ", mos, def"
    end

    it "no longer responds to adding a single tag.  dynamic dispatches are cooler than syntax sugar." do
      test = Video.new

      original_tags = test.set_tags(@entry_id,"gorillaz, pop, damon, albarn")

      expect{test.add_tag(@entry_id,"mos")}.to raise_error
    end

    it "should allow you to add admin tags onto an existing tag string without knowing the original tags" do
      test = Video.new

      original_tags = test.set_admin_tags(@entry_id,"gorillaz,pop,damon,albarn")

      expect(test.add_admin_tags(@entry_id,"mos,def")).to eq original_tags + ",mos,def"
    end

    it "no longer responds to adding a single admin tag" do
      test = Video.new

      original_tags = test.set_admin_tags(@entry_id,"gorillaz, pop, damon, albarn")

      expect{test.add_admin_tag(@entry_id,"mos")}.to raise_error
    end

    xit "should let you add categories onto an existing category string as well." do
      test = Video.new

      original_categories = test.set_categories(@entry_id,"peanuts#{rand(10)}")

      new_cats = "pirates#{rand(10)},waffles#{rand(10)}"
      expect(test.add_categories(@entry_id,new_cats)).to eq original_categories + ",#{new_cats}"
      check_string = original_categories + ",#{new_cats}"
      check_string.split(",").each do |category|
        cat = test.category_exists?(category)
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
      test = Video.new

      original_categories = test.set_categories(@entry_id,"peanuts#{rand(10)}")

      new_cats = "pirates#{rand(10)},waffles#{rand(10)}"
      test.add_categories(@entry_id,new_cats)
      check_string = original_categories + ",#{new_cats}"
      check_string.split(",").each do |category|
        cat = test.category_exists?(category)
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
      test = Video.new

      original_categories = test.set_categories(@entry_id,"peanuts#{rand(10)},pirates#{rand(10)}")

      new_cat = "waffles#{rand(10)}"
      expect{test.add_category(@entry_id,new_cat)}.to raise_error

      bob = KalturaBox.client.category_service.list.objects
      bob.each do |cat|
        if cat.name =~/^(waffles|pirates|peanuts)(.*)/
          KalturaBox.client.category_service.delete(cat.id)
        end
      end
    end

    it "should let you set multiple fields at once with set()" do
      test = Video.new

      name = "Mr Peanut's wild ride"
      description = "Man this is a random name"
      waffles = "Man waffles isn't an attribute"
      test.set(@entry_id,:name=>name,:description=>description,:waffles=>waffles)

      expect(test.get_name(@entry_id)).to eq name
      expect(test.get_description(@entry_id)).to eq description
    end

  end

end
