module KalturaBox
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates",__FILE__)
      desc "Copies the KalturaBox config file and upload JS to your app."

      def copy_config
        copy_file "kaltura_box.rb", "config/initializers/kaltura_box.rb"
      end

      def copy_javascript
        copy_file "kaltura_upload.js", "public/javascripts/kaltura_upload.js"
      end
    end
  end
end
