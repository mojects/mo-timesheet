class ReportsController < ApplicationController
  def index
    @reports = Report.all.map { |x| [x, timeframe(x)] }
  end

  def show
    @report = Report.find params[:id]
  end

  def new
  end

  def create
    generate_report
    redirect_to reports_path
  rescue Fee::NoPayrollError
    redirect_to '/no_payroll'
  end

  def destroy
    Report.find(params[:id]).destroy
    redirect_to reports_path
  end

  def xml
    render xml: Report.find(params[:report_id]).xml
  end

  private
  def generate_report
    parameters = report_params
    from, to = parameters.permit(:start_time, :finish_time).values.map(&:to_date)
    report = Report.create(report_params)
    TimeEntry.where(spent_on: from..to).
      map(&:to_user_detail).
      group_by { |x| x[:user_id] }.
      select { |user_id, _| User.find(user_id).active }.
      each do |user_id, user_details|
        user = User.find(user_id)
        Fee.transaction do
          UserReport.generate user_details, report.id, user
          Fee.generate_hourly_fee(user_details, report, user) rescue nil
          Fee.generate_monthly_fee(user_details, report, user) rescue nil
          Fee.generate_single_fee(report, user) rescue nil
        end
      end
    Fee.all.reject { |x| x.sum }.map(&:delete)
  end

  def report_params
    params.require(:report).permit(:start_time, :finish_time, :name)
  end

  def timeframe(report)
    "%s -- %s" % [report.start_time, report.finish_time]
  end
end
