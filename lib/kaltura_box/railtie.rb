require 'kaltura_box'
require 'kaltura_box/view_helpers'
require 'rails'

module KalturaBox
  class Railtie < Rails::Railtie
    initializer 'install kaltura_box' do
      $: << File.dirname(__FILE__) + '/../lib'

      ActionView::Base.send :include, KalturaBox::ViewHelpers
      require "kaltura"
    end
  end
end
