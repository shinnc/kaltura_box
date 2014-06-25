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

    context "remove" do
      let!(:category) { Category.add("new_cat2", "New Category 2") }
      it { expect{category.remove}.to change{Category.count}.by(-1) }
    end

  end

end
