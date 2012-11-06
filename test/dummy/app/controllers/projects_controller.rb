class ProjectsController < ApplicationController
  default_resource_actions index:{paginate: {per_page: 2}}
end
