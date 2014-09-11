class UserReport < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  has_many :user_details, :dependent => :destroy

  has_many :invoices_packs_user_reports
  has_many :invoices_packs, through: :invoices_packs_user_reports

  has_many :invoice_user_reports
  has_many :invoices, through: :invoice_user_reports

  def fees
    report.fees.select { |x| x.user == user }
  end

  def currency
    fees.map(&:currency).uniq.first
  end

  def total_hours
    fees.map { |x| x.user_details.map(&:hours).sum }.sum.round(2)
  end

  def amount
    fees.
      group_by { |x| x.currency || x.payroll.currency }.
      inject({}) { |r, (currency, fees)| r.merge currency => fees.map(&:sum).sum }
  end

  def self.generate user_details, report_id, user
    report_params = {
      user_id: user.id,
      report_id: report_id,
      name: "Report for employee #{user.name}"
    }
    report = UserReport.create report_params
    user_details.each { |x| x.update(user_report_id: report.id) }
    report
  end
end
