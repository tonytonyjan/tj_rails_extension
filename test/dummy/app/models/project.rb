class Project < ActiveRecord::Base
  attr_accessible :name, :tasks_attributes
  has_many :tasks, dependent: :destroy
  accepts_nested_attributes_for :tasks, allow_destroy: true, reject_if: :all_blank
end
