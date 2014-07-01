require 'active_support'
require 'kaltura_box/entry/metadata/class_methods'
require 'kaltura_box/entry/metadata/class_and_instance_methods'

module KalturaBox
  module Entry

    ##
    # The Metadata module provides methods that get/set and add metadata to the
    # Kaltura installation.
    #
    # @author Patrick Robertson
    ##
    module Metadata

      ##
      # @private
      ##
      def self.included(base)
        base.extend ClassAndInstanceMethods
        base.extend ClassMethods
        base.class_eval do
          include ClassAndInstanceMethods
        end
        super
      end

      ##
      # @private
      ##
      def method_missing(name, *args)
        method_name = name.to_s
        unless self.class.generated_methods?
          self.class.define_attribute_methods
          if self.class.generated_methods.include?(method_name)
            return self.send(name,*args)
          else
            super
          end
        else
          super
        end
      end

      ##
      # @private
      ##
      def respond_to?(method)
        case method.to_s
        when /^(get|set)_(.*)/
          valid_entry_attribute?($2.to_sym) || super
        when /^(add)_(.*)/
          (valid_entry_attribute?($2.pluralize.to_sym) && valid_add_attribute?($2) ) || super
        else
          super
        end
      end

      ##
      # Gets a Kaltura::MediaEntry given a Kaltura entry.
      #
      # @param [String] video_id Kaltura entry_id of the video.
      #
      # @return [Kaltura::MediaEntry] The MediaEntry object for the Kaltura entry.
      # @raose [Kaltura::APIError] Raises a kaltura error if it can't find the entry.
      ##
      def get_entry(entry_id)
        client = KalturaBox::Client.update_session
        client.media_service.get(entry_id)
      end

      ##
      # Sets a specific Kaltura::MediaEntry attribute given a Kaltura entry.
      # This method is called by method_missing, allowing this module set attributes based
      # off of the current API wrapper, rather than having to update along side the API wrapper.
      #
      # @param [String] attr_name The attribute to set.
      # @param [String] entry_id The Kaltura entry ID.
      # @param [String] value The value you wish to set the attribute to.
      #
      # @return [String] Returns the value as stored in the Kaltura database.  Tag strings come back
      #   slightly funny.
      #
      # @raise [Kaltura::APIError] Passes Kaltura API errors directly through.
      ##
      def set_attribute(attr_name,entry_id,value)
        client = KalturaBox::Client.update_session

        add_categories_to_kaltura(value) if (attr_name =~ /^(.*)_categories/ || attr_name =~ /^categories/)

        media_entry = Kaltura::KalturaMediaEntry.new
        media_entry.send("#{attr_name}=",value)
        client.media_service.update(entry_id,media_entry).send(attr_name.to_sym)

      end

      ##
      # Sets multiple Kaltura::MediaEntry attributes in one convienant method.
      #
      # @param [String] entry_id The Kaltura entry ID.
      # @param [Hash] attributes
      # @option attributes [String] :attribute A Kaltura::MediaEntry attribute to set
      ##
      def set(entry_id, attributes={})
        KalturaBox::Client.update_session

        attributes.each do |key,value|
          attribute = key.to_s
          set_attribute(attribute,entry_id,value) if valid_entry_attribute?(key)
        end
      end
      ##
      # @private
      ##
      def add_categories_to_kaltura(categories)
        client = KalturaBox::Client.update_session

        categories.split(",").each do |category|
          unless category_exists?(category)
            cat = Kaltura::KalturaCategory.new
            cat.name = category
            client.category_service.add(cat)
          end
        end
      end

      ##
      # @private
      ##
      def category_exists?(category_name)
        client = KalturaBox::Client.update_session

        category_filter = Kaltura::KalturaCategoryFilter.new
        category_filter.full_name_equal = category_name
        category_check = client.category_service.list(category_filter).objects
        if category_check.nil?
          false
        else
          category_check
        end
      end


      ##
      # Appends a specific Kaltura::MediaEntry attribute to the end of the original attribute given a Kaltura entry.
      # This method is called by method_missing, allowing this module add attributes based
      # off of the current API wrapper, rather than having to update along side the API wrapper.
      #
      # @param [String] attr_name The attribute to set.
      # @param [String] entry_id The Kaltura entry ID.
      # @param [String] value The value you wish to append the attribute with.
      #
      # @return [String] Returns the value as stored in the Kaltura database.  Tag strings come back
      #   slightly funny.
      #
      # @raise [Kaltura::APIError] Passes Kaltura API errors directly through.
      ##
      def add_attribute(attr_name,entry_id,value)
        client = KalturaBox::Client.update_session


        add_categories_to_kaltura(value) if (attr_name =~ /^(.*)_categor(ies|y)/ || attr_name =~ /^categor(ies|y)/)

        old_attributes = client.media_service.get(entry_id).send(attr_name.to_sym)
        media_entry = Kaltura::KalturaMediaEntry.new
        media_entry.send("#{attr_name}=","#{old_attributes},#{value}")
        client.media_service.update(entry_id,media_entry).send(attr_name.to_sym)
      end

    end
  end
end
