class PostsController < ApplicationController
  load_and_authorize_resource
  default_resource_actions index:{paginate: {per_page: 10}}
end
