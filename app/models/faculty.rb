class Faculty < ApplicationRecord
  belongs_to :user
  validates_associated :user
  has_and_belongs_to_many :projects, join_table: "project_faculties"
  attr_accessor :name
  attr_accessor :email

  # validates :department, presence: true, length: { maximum: 255 } # Presence and max length for department
end
