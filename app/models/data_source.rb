class DataSource < ActiveRecord::Base
  has_many :time_entries
  enum primary: { no: 'no', yes: 'yes' }
end
