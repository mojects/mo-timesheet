class UserReportsController < ApplicationController
  def index
    @user = User.find params[:user_id]
    @reports_history = @user.user_reports.order(:id => :desc).
      page(params[:page]).per(12)
  end

  def edit
    @user_report = UserReport.find params[:id]
    @info = report_info
  end

  def show
    @user_report = UserReport.find params[:id]
    report = @user_report.report
    @new_fee = Fee.new
    @add_fee_path = "/reports/#{report.id}/user_reports/#{@user_report.id}/fees"
    @reports_history = @user_report.user.user_reports.order(:id => :desc).
      page(params[:page]).per(3)
  end

  def update
    user_report = UserReport.find params[:id]
    user_report.update(summary: params['summary'])
    redirect_to user_report_path(user_report)
  end

  def update_summary
    UserReport.find(params[:user_report_id]).update(summary: params['summary'])
    render :nothing => true, :status => :ok
  end

  def update_fee
    fee_params = params.permit(:comment, :sum, :currency).
      inject({}) { |r, (k, v)| r.merge k => v.squish }
    Fee.find(params[:fee_id]).update(fee_params)
    render :nothing => true, :status => :ok
  end

  def destroy
    UserReport.find(params[:id]).destroy
    redirect_to reports_path
  end

  protected
  def report_info
    { 'Summary'     => [@user_report.summary, 'summary'] }
  end

  def columns
    report_info.map { |_, (_, x)| x }
  end
end
