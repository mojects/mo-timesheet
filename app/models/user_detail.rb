class UserDetail < ActiveRecord::Base
  belongs_to :user
  belongs_to :fee
  belongs_to :user_report

  def spent
    if spent_on
      spent_on.seconds_since_midnight.zero? ? spent_on.to_date : spent_on
    else
      start_time
    end
  end

  def elastic_data(one_hour_cost)
    escape({ user: user.last_name,
      project: project,
      issue_title: task,
      comment: comment,
      hours: hours,
      cost: hours * one_hour_cost,
      timestamp: spent_on
    })
  end

  def escape(hash)
    Hash[hash.map do |k, v|
      new_v = String === v ? ERB::Util.json_escape(v) : v
      [k, new_v]
    end]
  end
end
