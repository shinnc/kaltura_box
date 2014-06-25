require 'spec_helper'
require 'active_record'

class Category < ActiveRecord::Base
  include KalturaBox::Category
end

describe "KalturaBox::Category" do

  before(:all) { KalturaBoxTest.setup! }

  describe "class methods" do

    let(:categories) { Category.list }

    before { KalturaBoxTest.setup_db! }

    context "list" do
      it { expect(categories.class).to eq Array }
    end

    context "update all categories" do
      it { expect{Category.update_all_categories!}.to change{Category.count}.from(0).to(categories.count) }
    end

    context "add" do
      it { expect{Category.add("new_cat", "New Category", true)}.to change{Category.count}.by(1) }
    end

  end

  describe "instance methods" do

    before { KalturaBoxTest.setup_db! }

    let!(:category) { Category.add("new_cat2", "New Category 2") }

    context "update" do
      xit "Looking for a way to remove the updated category on Kaltura" do
        expect{category.edit(name: "new_cat3", description: "New Category 3")}.to change{category.name}.from("new_cat2").to("new_cat3")
      end
    end

    context "remove" do
      let!(:category) { Category.add("new_cat4", "New Category 4") }
      it { expect{category.remove}.to change{Category.count}.by(-1) }
    end

  end

end
