class User < ActiveRecord::Base
  has_many :payrolls, :dependent => :destroy
  has_many :user_reports, :dependent => :destroy
  has_many :reports
  has_many :time_entries
  has_many :fees

  has_many :invoices_packs_user_reports
  has_many :invoices_packs, through: :invoices_packs_user_reports

  def name
    "#{first_name} #{last_name}"
  end
end

User.inheritance_column = :_type_disabled
