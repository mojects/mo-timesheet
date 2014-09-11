module ApplicationHelper
  def sync_last_month_path
    from = (Date.today - 1.month).beginning_of_month
    to = Date.today
    connectors_synchronize_path(from: from, to: to)
  end
end
