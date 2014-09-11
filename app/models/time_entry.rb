class TimeEntry < ActiveRecord::Base
  belongs_to :report
  belongs_to :user

  def spent
    if spent_on
      spent_on.seconds_since_midnight.zero? ? spent_on.to_date : spent_on
    else
      start_time
    end
  end

  def to_user_detail
    common_fields = %w(user_id project hours comment spent_on task)
    attrs = attributes.
      select { |k, _| common_fields.include? k }.
      merge('time_entry_id' => id)
    UserDetail.create(attrs)
  end
end
