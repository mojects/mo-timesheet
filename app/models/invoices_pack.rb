class InvoicesPack < ActiveRecord::Base
  has_many :invoices, :dependent => :destroy
  belongs_to :report

  has_many :invoices_packs_user_reports
  has_many :user_reports, through: :invoices_packs_user_reports

  def post_to_elastic
    invoices.each { |x| x.post_to_elastic }
  end

  def zipped
    file = Rails.root + 'app/assets/pdf/' + "pack_#{id}.zip"
    invoices_paths = invoices.map(&:document_file_name).join(' ')
    system "rm #{file}"
    command = "zip -j %s %s" % [file, invoices_paths]
    system command
    file
  end
end
