# Represents a single event on a user's schedule
class Event < ApplicationRecord
  belongs_to :schedule
  validates :name, :start_time, :end_time, presence: true

  include Scoping::Scopey

  def self.scoped_by_day(day, roles = nil)
    records = ActiveRecord::Base.connection.execute(raw_sql(day, roles))
    fields = records.fields
    records.values.map { |vals| Event.instantiate(Hash[fields.zip(vals)]) }
  end

  # Returns a string of the days in which this event repeats
  # For example: "Mon, Tue, Sat"
  def days_as_string
    day_string = ''
    day_map = %w[Sun Mon Tue Wed Thu Fri Sat]
    days.each { |d| day_string << day_map[d] + ', ' }
    day_string[0..(day_string.length - 3)]
  end

  # Length of event as a decimal
  # An event of 1 hr 30 min returns 1.5
  def time_length
    (end_time.hour - start_time.hour) + (end_time.min - start_time.min) / 60.0
  end

  def self.raw_sql(day, roles)
    sql = 'SELECT DISTINCT(events.*) FROM events '
    if roles.present? && !roles.empty?
      sql += "INNER JOIN (SELECT * FROM scopes WHERE #{roles_conditions(roles)}) "\
      ' sub_scopes ON (sub_scopes.resource_id = events.id) '
    end
    sql + "WHERE #{day}=ANY(events.days)"
  end

  def self.roles_conditions(roles)
    condition = ''
    roles.each_with_index do |r, i|
      condition +=  if i.zero?
                      "scopes.role_id = #{r} "
                    else
                      "OR scopes.role_id = #{r} "
                    end
    end
    condition
  end
end
