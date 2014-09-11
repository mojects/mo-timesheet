class InvoicesController < ApplicationController
  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.create(invoice_params)
    report = Report.find params[:report_id]
    user_report = UserReport.find params[:user_report_id]
    @invoice.generate(report, user_report)
    @invoice.save
    redirect_to report_user_report_invoices_path(report.id, user_report.id)
  end

  def index
    report = Report.find params[:report_id]
    user_report = UserReport.find params[:user_report_id]
    user = User.find user_report.user_id
    @invoices = Invoice.where user_id: user.id, report_id: report.id
  end

  def user_invoices
    @invoices = Invoice.where user_id: params[:id]
    @user = User.find params[:id]
  end

  def edit
    @invoice = Invoice.find params[:id]
    @info = invoice_info
  end

  def show
    @invoice = Invoice.find params[:id]
    @user = @invoice.user
  end

  def update
    @invoice = Invoice.find params[:id]
    @invoice.update description: params[:description]
    @invoice.generate_pdf @invoice.generate_document_path!
    redirect_to @invoice
  end

  def destroy
    invoice = Invoice.find params[:id]
    invoice.destroy
    redirect_to invoices_packs_path
  end

  def download
    invoice = Invoice.find params[:id]
    (redirect_to '/no_pdf'; return) unless invoice.document_file_name
    send_file invoice.document_file_name,
      type: 'application/pdf',
      filename: "#{invoice.user.name}_#{invoice.invoice_number}"
  end

  private
  def invoice_info
    {
      'Description of invoice' => [@invoice.description, 'description']
    }
  end

  def invoice_params
    params.require(:invoice).permit(:description)
  end
end
