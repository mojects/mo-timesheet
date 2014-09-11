class Invoice < ActiveRecord::Base
  include Invoice2PDF

  belongs_to :invoices_pack
  belongs_to :user
  belongs_to :report

  has_many :invoice_user_reports
  has_many :user_reports, through: :invoice_user_reports

  def generate(report, user_report, conversion_rates = {'USD' => 1.0})
    user = User.find user_report.user_id
    amount = convert_currencies(user_report.amount, conversion_rates)
    return(false) if amount.zero? || user.tax_percent.nil?
    tax_coef = 1 - user.tax_percent / 100
    full_salary = amount / tax_coef
    tax_amount = ((user.tax_percent / 100) * full_salary).round(2)
    update user_id: user.id, report_id: report.id,
      description: user_report.summary, amount_without_taxes: amount,
      tax_amount: tax_amount
    InvoiceUserReport.create(invoice_id: id, report_user_id: user_report.id)
    generate_pdf generate_document_path!
    true
  end

  def convert_currencies(amount, conversion_rates)
    amount.inject(0) { |r, (currency, sum)| r + sum.to_f / conversion_rates[currency].to_f }
  end

  def generate_document_path!
    parent_dir = Rails.root + 'public/assets/pdf'
    directory = parent_dir + id.to_s
    Dir.mkdir(parent_dir) unless Dir.exists?(parent_dir)
    Dir.mkdir(directory) unless Dir.exists?(directory)
    path = directory + "#{user.last_name}_#{Time.now.to_i}"
    update(document_file_name: path.to_s)
    path.to_s
  end

  def total_amount
    (amount_without_taxes + tax_amount).round 2
  end

  def invoice_number
    user.first_name[0] + user.last_name[0] +
    ((Date.today.year - 2013) * 12 + Date.today.month).to_s +
    sprintf("%03d" % user.id)
  end

  def invoice_description
    (description || '') +
    ': As per contract #' +
    user.first_name[0] + user.last_name[0] +
    sprintf("%02d.%02d.%02d" %
      [user.date_of_contract.month, user.date_of_contract.day, (user.date_of_contract.year % 100)])
  end

  def post_to_elastic
    index_json = index_part
    hours = user_report.total_hours
    one_hour_cost = (amount_without_taxes + tax_amount) / hours
    data = user_report.fees.map do |fee|
      fee.user_details.inject('') do |fee_data, user_detail|
        [fee_data, index_json, user_detail.elastic_data(one_hour_cost).to_json].
          reject(&:empty?).join("\n")
      end
    end
    final = data.join("\n").gsub(/\n{2,}/, "\n") + "\n"
    HTTParty.post "#{ELASTIC[:address]}/_bulk", body: final
  end

  def index_part
    { index: { _index: ELASTIC[:index], _type: ELASTIC[:type] }}.to_json
  end

  def user_report
<<<<<<< HEAD
    report.user_reports.find { |x| x.user_id == user_id }
=======
    user_reports.first || report.user_reports.find { |x| x.user_id == user_id }
>>>>>>> master
  end
end
