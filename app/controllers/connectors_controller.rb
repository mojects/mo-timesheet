class ConnectorsController < ApplicationController
  protect_from_forgery except: :index

  def index
    @connectors = Rails::Engine.descendants.
      reject { |x| x == Rails::Application }.
      select { |x| x.config.root.to_s.include? 'plugins/connectors' }.
      map { |x| x.engine_name }
  end

  def synchronize
    timeframe = params.permit(:from, :to).values.map { |x| Date.parse x }
    timeframe[1] += 1.day
    UserConnector.descendants.map { |x| x.synchronize *timeframe }
    TimeEntryConnector.descendants.map { |x| x.synchronize *timeframe }
    redirect_to '/'
  end
end
