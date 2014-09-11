require_dependency "xlsx_import/application_controller"

module XlsxImport
  class XlsxController < ApplicationController
    layout 'application'

    def index
    end

    def new
      @users = User.all.select(&:active)
    end

    def create
      entries = XlsxImport.import(params[:time_entries].path)
      has_old = entries.find { |x| Time.now - x[:spent_on] > 10.years.seconds }
      redirect_to 'xlsx_import/too_old' if has_old
      employee_id = params[:employee]
      entries.each { |x| TimeEntry.create x.merge(user_id: employee_id) }
      redirect_to '/time_entries'
    end

    def too_old
    end
  end
end
