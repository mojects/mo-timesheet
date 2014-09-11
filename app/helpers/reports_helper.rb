module ReportsHelper
  def link_to_update_user(report, user_report)
    link_to 'Update', edit_report_user_report_path(report.id, user_report.id)
  end

  def link_to_invoices_user(report, user_report)
    if user_report.status == 'invoiced'
      link_to 'Invoices',
        report_user_report_invoices_path(report.id, user_report.id)
    else
      link_to 'Generate invoice',
        new_report_user_report_invoice_path(report.id, user_report.id)
    end
  end

  def link_to_next_report(user_report)
    report = user_report.report
    next_user_report = report.user_reports.find { |x| x.id > user_report.id }
    if next_user_report
      link_to 'Next report', report_user_report_path(report, next_user_report)
    else
      'This is the last report in this pack'
    end
  end

  def link_to_destroy_fee(report, user_report, fee)
    link_to fa_icon('times-circle'),
      "/reports/#{report.id}/user_reports/#{user_report.id}/fees/#{fee.id}",
      method: :delete
  end
end
