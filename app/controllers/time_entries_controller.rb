class TimeEntriesController < ApplicationController
  protect_from_forgery except: :index

  def index
    @entries = TimeEntry.all.order(:spent_on => :desc).page(params[:page]).per(10)
  end

  def show
    @user = User.find params[:id]
    @entries = @user.time_entries.order(:spent_on => :desc).page(params[:page]).per(10)
  end

  def destroy
    TimeEntry.find(params[:id]).destroy
    redirect_to time_entries_path
  end

  def syncronize
    timeframe = params.permit(:from, :to).values.map { |x| Date.parse x }
    timeframe[1] += 1.day
    TimeEntryConnector.synchronize *timeframe
    redirect_to time_entries_path
  end
end
