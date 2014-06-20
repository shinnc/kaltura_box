require 'spec_helper'

describe "KalturaBox::APIWrapper" do
  it { expect( KalturaBox::APIWrapper.new ).to eq KalturaBox.config }
end
