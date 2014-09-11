class Fee < ActiveRecord::Base
  belongs_to :report
  belongs_to :payroll
  has_many :user_details, :dependent => :destroy

  def user
    user_id ? User.find(user_id) : payroll.user
  end

  def amount
    payroll ? payroll.amount : nil
  end

  def self.generate_single_fee(report, user)
    timeframe = report.start_time..report.finish_time
    payrolls = Payroll.where(user_id: user.id, effective_since: timeframe, work_type: 'single')
    payrolls.each do |payroll|
     Fee.create(report_id: report.id, work_type: 'single',
       comment: payroll.name, sum: payroll.amount, payroll_id: payroll.id,
       user_id: user.id, currency: payroll.currency)
    end
  end

  def self.generate_hourly_fee(user_details, report, user)
    timeframe = Date.new..report.finish_time
    payrolls_and_fees = hourly_payrolls_fees(timeframe, user.id, report.id)
    user_details.each do |detail|
      fee = payrolls_and_fees.find do |(payroll, _)|
        detail.spent_on >= payroll.effective_since
      end
      raise NoPayrollError unless fee
      fee = fee.last
      detail.update(fee_id: fee.id)
    end
    payrolls_and_fees.
      each { |(_, fee)| fee.update(hours: fee.user_details.map(&:hours).sum) }
    update_hourly_sum payrolls_and_fees
  end

  def self.update_hourly_sum(payrolls_and_fees)
    payrolls_and_fees.each { |(p, f)| f.update(sum: (f.hours || 0) * p.amount) }
  end

  def self.generate_monthly_fee(user_details, report, user)
    timeframe = Date.new..report.finish_time
    payroll_and_fee = monthly_payroll_fee(timeframe, user.id, report.id)
    return unless payroll_and_fee
    payroll, fee = *payroll_and_fee
    hours = user_details.map(&:hours).sum
    user_details.map { |x| x.update(fee_id: fee.id) }
    fee.update(hours: hours, sum: payroll.amount, work_type: 'monthly')
    fee
  end

  def self.monthly_payroll_fee(timeframe, user_id, report_id)
    payrolls_fees(timeframe, user_id, report_id).
      find do |(payroll, _)|
        payroll.work_type == 'monthly' &&
        payroll.effective_since <= timeframe.first
      end
  end

  def self.hourly_payrolls_fees(timeframe, user_id, report_id)
    payrolls_fees(timeframe, user_id, report_id).
      select { |(payroll, _)| payroll.work_type == 'hourly' }
  end

  def self.payrolls_fees(timeframe, user_id, report_id)
    Payroll.where(effective_since: timeframe, user_id: user_id).
      sort_by { |x| -x[:effective_since].to_time.to_i }.
      map do |x|
        fee = Fee.create(payroll_id: x.id, report_id: report_id,
          currency: x.currency, user_id: user_id)
        [x, fee]
      end
  end

  class NoPayrollError < RuntimeError; end
end
