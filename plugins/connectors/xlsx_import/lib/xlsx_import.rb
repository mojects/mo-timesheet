require 'xlsx_import/engine'
require 'roo'

module XlsxImport
  # ["Date", "Start", "End", "Spent", "Task"]
  EMPTY_ROW = [nil, nil, nil, 0.0, nil]

  def import(path)
    document = Roo::Excelx.new path, nil, :ignore
    date = nil
    (document.last_row + 1).times.inject([]) do |result, row_number|
      row = document.row(row_number)
      next(result) if empty?(row)
      date = row.first.to_time.to_i if date?(row)
      begin
        result << parse_time_entry(row, date) if time_entry?(row)
        result
      rescue ActiveRecord::RecordNotFound
        next(result)
      end
    end
  end

  def date?(row)
    Date === row.first
  end

  def empty?(row)
    row == EMPTY_ROW
  end

  def time_entry?(row)
    row[1..3].all? { |x| seconds(x) != 0 } rescue false
  end

  def parse_time_entry(row, date)
    {
      start_time: Time.at(date + seconds(row[1])),
      spent_on: Time.at(date + seconds(row[1])),
      finish_time: Time.at(date + seconds(row[2])),
      hours: (row[3].to_f / 3600).round(2),
      comment: row[4]
    }
  end

  def seconds(value)
    Numeric === value ? value.to_i : value.to_time.seconds_since_midnight
  end

  extend XlsxImport
end
