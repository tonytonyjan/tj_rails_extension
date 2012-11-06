class PostsController < ApplicationController
  default_resource_actions index:{paginate: {per_page: 10}}
end
