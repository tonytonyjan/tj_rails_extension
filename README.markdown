## Usage

Append to `Gemfile`:

    gem "tj_rails_extension", :git => "git://github.com/tonytonyjan/tj_rails_extension.git"

And then:

    rake tj:install

application.js

    ...
    //= require jquery
    //= require jquery_ujs
    //= require bootstrap
    //= require jquery_nested_form
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