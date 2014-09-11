class Report < ActiveRecord::Base
  has_many :users, through: :user_reports
  has_many :user_reports, :dependent => :destroy
  has_many :fees, :dependent => :destroy

  # Report has_many (UserReport has_many TimeEntries)
  def xml
    user_entries = user_reports.inject({}) do |r, x|
      r.merge(x.user_id => x.user_details.map(&:attributes))
    end
    user_reports_with_time_entries = user_reports.map do |x|
      x.attributes.merge(time_entries: user_entries[x.user_id], user: x.user)
    end
    attributes.merge(user_reports: user_reports_with_time_entries).to_xml(root: 'report')
  end
end
