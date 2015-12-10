# KalturaBox

[![Build Status](https://travis-ci.org/shinnyx/kaltura_box.svg)](https://travis-ci.org/shinnyx/kaltura_box)
[![Gem Version](https://badge.fury.io/rb/kaltura_box.svg)](http://badge.fury.io/rb/kaltura_box)

Customized Ruby wrapper for Kaltura API on Active Record

**THIS GEM IS NOT BEING MAINTAINED ANYMORE**

Heavily influenced and continuation of [Kaltura_Fu](https://github.com/Velir/kaltura_fu)

## Installation

Add this line to your application's Gemfile:

    gem 'kaltura_box'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kaltura_box

## Usage

```ruby
# For the Entry class
class Video < ActiveRecord::Base
  include KalturaBox::Entry
end

# Category class
class Category < ActiveRecord::Base
  include KalturaBox::Category
end

# Entry listing from Kaltura
Video.video_list

# Search
Video.video_list("search string here")

# Create videos based on Kaltura entries
Video.update_all_videos!

# Retrieve a kaltura entry
video = Video.new(entry_id: "0_7ivwzhbh")
video.get

# Tagging
video.set_tags = "noodles, food, yummy" # Create a new set of tags
video.add_tags = "rice, fruits" # Add more tags to the existing tag list
video.add_tag("bacon") # Add a single tag
video.get_tags # Retrieve tags

# Kaltura Metadata
video.set(name: "bla", description: "blablabla")
video.set_name = "bla"
video.set_description = "blablabla"
```

## Contributing

1. Fork it ( https://github.com/shinnyx/kaltura_box/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
