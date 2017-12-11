# ScheduleHelper: to help schedule and events
module ScheduleHelper
  # Array of hours dispalyed on the calendar, in 24 hr format
  def calendar_hours
    (6..22).to_a
  end

  # Start hour for events displayed on calendar
  def calendar_start_hour
    calendar_hours[0]
  end

  # Height of a single hour on calendar (in pixels)
  # Note: if this values is changed, changes must be made in CSS as well
  def calendar_hour_size_pixels
    30
  end

  # Days of the week
  # Hopefully you won't have to change this
  def days_of_week
    %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
  end

  # Finds all events on a given day, 0 being Sunday
  def all_events_on_day(day_num)
    Event.scoped_by_day(day_num, params[:roles])
  end

  # Height (in pixels) of a single event block
  def event_block_height(event)
    event.time_length * calendar_hour_size_pixels
  end

  # Distance (in pixels) from the top of the calendar
  def event_block_offset(event)
    hour_off = (event.start_time.hour - calendar_start_hour) * calendar_hour_size_pixels
    min_off = (event.start_time.min / 60.0) * calendar_hour_size_pixels
    hour_off + min_off
  end
end
