class PayrollsController < ApplicationController
  PAYROLL_INFO = %w(name amount effective_since work_type currency)

  def index
    @user = User.find params[:user_id]
    payrolls = @user.payrolls || []
    @payrolls_info = payrolls.map { |x| [info(x), x] }
    @payroll = Payroll.new
  end

  def edit
    @payroll = Payroll.find params[:id]
    @route = "/users/#{params[:user_id]}/payrolls/#{params[:id]}"
  end

  def update
    @payroll = Payroll.find(params[:id])
    @payroll.update(attrs)
    redirect_to user_payrolls_path(params[:user_id])
  end

  def new
    @payroll = Payroll.new
    @route = "/users/#{params[:user_id]}/payrolls"
  end

  def create
    payroll = Payroll.create attrs.merge(user_id: params[:user_id])
    redirect_to user_payrolls_path(params[:user_id])
  end

  def destroy
    Payroll.find(params[:id]).destroy
    redirect_to user_path(params[:user_id])
  end

  private
  def info(payroll)
    payroll.attributes.select { |x| PAYROLL_INFO.include? x }
  end

  def attrs
    params.require(:payroll).permit(PAYROLL_INFO.map(&:to_sym))
  end
end
