class Payroll < ActiveRecord::Base
  belongs_to :user
  has_one :fee
end
