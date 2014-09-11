module InvoicesPacksHelper
  def amount(user_report)
    user_report.fees.
      group_by { |x| x.currency || x.payroll.currency }.
      map { |(currency, fees)| "%d %s" % [fees.map(&:sum).sum, currency] }.
      join(', ')
  end
end
