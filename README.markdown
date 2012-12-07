## Usage

Append to `Gemfile`:

    gem "tj_rails_extension", github: 'tonytonyjan/tj_rails_extension'

And then:

    rake tj:install:gems
    bundle install
    rake tj:install

application.js

    ...
    //= require jquery
    //= require jquery_ujs
    //= require bootstrap
    //= tj_rails_extension
    //= require_tree .
    $(document).ready(UTIL.init);
    ...

application.css

    ...
    *= require bootstrap
    *= require_self
    *= require bootstrap-responsive
    *= require_tree .
    ...

application.html.erb

    ...
    <body class="<%= controller_name %> <%= action_name %>" data-controller="<%= controller_name %>" data-action="<%= action_name %>">
      <%= notice_message %>
      <%= page_header @header if @header %>
      <%= yield %>
    </body>
    ...

application_controller.rb

    class ApplicationController < ActionController::Base
      ...
      default_rescue
      ...  
    end
