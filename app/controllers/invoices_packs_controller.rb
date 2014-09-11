class InvoicesPacksController < ApplicationController
  def new
    pack = InvoicesPack.new
    @user_reports = UserReport.where report_id: params[:report_id], status: 'pending'
    @report = Report.find params[:report_id]
    @conversion_rates = report_currencies(@report).
      map { |x| [x, conversion_rate('USD', x)] }
  end

  def index
    @packs = InvoicesPack.all
  end

  def show
    @invoices_pack = InvoicesPack.find params[:id]
  end

  def create
    conversion_rates = params[:conversion_rates]
    pack = InvoicesPack.create
    candidates = (params[:UserReport][:status] || []).map(&:to_i)
    user_reports = UserReport.where(report_id: params[:report_id]).
      select { |x| candidates.include? x.id }
    report = Report.find params[:report_id]
    user_reports.each do |user_report|
      invoice = Invoice.new
      next unless invoice.generate(report, user_report, conversion_rates)
      invoice.update invoices_pack_id: pack.id
      user_report.update status: 'invoiced'
    end
    pack.save
    redirect_to invoices_packs_path
  end

  def destroy
    InvoicesPack.find(params[:id]).destroy
    redirect_to invoices_packs_path
  end

  def to_elastic
    InvoicesPack.eager_load(:invoices => [:report, :user, :user_reports]).find(params[:id]).post_to_elastic
    redirect_to invoices_packs_path
  end

  def download
    file = InvoicesPack.find(params[:id]).zipped
    send_file file,
      type: 'application/zip',
      filename: "invoices"
  end

  private
  def report_currencies(report)
    report.fees.map { |x| x.currency || x.payroll.currency }.uniq
  end

  def conversion_rate(from, to)
    if from == 'USD' && to == 'RUB'
      return rate_from_raiffeisen
    end
    currencies = "%s-%s" % [from, to]
    address = "http://www.freecurrencyconverterapi.com/api/convert?q=#{currencies}&compact=y"
    HTTParty.get(address)[currencies]['val'].to_s
  end

  def rate_from_raiffeisen
    doc = Nokogiri::HTML(open('http://www.raiffeisen.ru/'))
    doc.css('div.rank-valut').text.split[3]
  end
end
