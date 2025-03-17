class Student < ApplicationRecord
  belongs_to :user


  validates_associated :user

  attr_accessor :email
  attr_accessor :name
end
