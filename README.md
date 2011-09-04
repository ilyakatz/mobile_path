Mobile Path
--------------
**Homepage**: [http://www.velir.com](http://www.velir.com)
**Author**: [Patrick Robertson](mailto:patrick.robertson@velir.com)
**Copyright**: 2011
**License**: [MIT License](file:LICENSE.txt)

About Mobile Path
-----------------

Mobile Path is a really simple gem for giving your Rails application a separate view path and subdomain specifically for mobile devices.  It takes a different approach to mobile views than [mobile_fu](https://github.com/brendanlim/mobile-fu) for a couple of reasons:

* The .mobile.erb methodology doesn't work out with JQuery Mobile and I sort of like JQueryMobile.
* If all you need is a new layout, it's frustrating to write a pile of .mobile.erb views.  Mobile Path drops back to 
  your already defined view_path gracefully.

Installation
------------
Mobile Path is only suitable for Rails 3.0+ apps.  You can add it to your Gemfile like so:

    #Gemfile
    gem "mobile_path"
    
You can override some of the defaults in your config/initializers/ folder like so:

    #config/initializers/mobile_path.rb
    MobilePath.configure do |config|
      config.subdomain = "mobile"
      config.mobile_view_path = "mobizzle"
      config.mobile_device_regex = /(iPhone|Android)/
    end

Configure your environment for appropriate top level domain length such as the following examples

    development.rb
    #   lvh.me = this is an alias for localhost
    config.action_dispatch.tld_length=1

    others

    #   staging.mysite.com
    #   config.action_dispatch.tld_length=2

Usage
-----

You can include this bad boy right into your ApplicationController like so:

    #app/controllers/application_controller.rb
    ApplicationController < ActionController::Base
      include MobilePath
    end
I'd rather give you the capability to explicitly include the file rather than insert it 
into ActionController::Base for you.  You may only want to only use mobile views for your
admin panel, or have some use case I don't foresee.  

For any views you'd like to make mobile you'll then just need to add them to app/mobile_views/ .
You can change the folder that Mobile Path will prepend to the view_path as mentioned earlier.

If you'd like to let users swap between the normal/mobile layouts, you'll need links similar to this:
    
    <%= link_to "View full site", url_for(:full_site => 1) %>
    <%= link_to "View mobile site", url_for(:mobile_site => 1) if mobile_browser? %>


Contributing to mobile_path
---------------------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Copyright (c) 2011 Velir. See LICENSE.txt for
further details.

