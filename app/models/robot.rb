require 'scrapper'

class Robot < ActiveRecord::Base
  validates :host, presence: true
  validates :host, uniqueness: true
  validates :rules, presence: true

  attr_accessible :host, :rules
end