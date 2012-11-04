class PostsController < ApplicationController
  before_filter{|c|
    c.resource!(index: {records: Post.limit(2)})
  }
  def create
  end
  def update
  end
  def destroy
  end
end
