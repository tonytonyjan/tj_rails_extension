class StoriesController < ApplicationController
  load_and_authorize_resource
  default_resource_actions
  default_rescue
end
