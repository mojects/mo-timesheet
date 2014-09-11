class FeesController < ApplicationController
  def create
    Fee.create(fee_params)
    redirect_to(report_user_report_path(params[:report_id], params[:user_report_id]) + '#fees')
  end

  def fee_params
    params.require(:fee).
      permit(:work_type, :comment, :sum, :currency).
      merge report_id: params[:report_id], user_id: UserReport.find(params[:user_report_id]).user.id
  end

  def destroy
    Fee.find(params[:id]).destroy
    redirect_to(report_user_report_path(params[:report_id], params[:user_report_id]) + '#fees')
  end
end
