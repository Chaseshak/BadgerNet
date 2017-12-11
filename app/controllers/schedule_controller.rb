# ScheduleController controls adding/editing/viewing events on schedules
class ScheduleController < ApplicationController
  def index
    @user = current_user
    if @user.coach?
      render 'admin_index'
    else
      athlete_view
      render 'index'
    end
  end

  def create_event
    @user = current_user
    @event = Event.create(name: params[:name], schedule_id: @user.schedule.id,
                          start_time: params[:time]['start'],
                          end_time: params[:time]['end'], days: build_days_array(params))
    @event.scopify(current_user.role_ids)
    # success
    flash[:success] = "Successfully added \"#{@event.name}\""
    redirect_to action: 'index'
  end

  def destroy_event
    @event = Event.find(params[:event_id])
    name = @event.name
    @event.destroy
    flash[:success] = "Successfully removed \"#{name}\""
    redirect_to action: 'index'
  end

  private

  def athlete_view
    @schedule = if @user.schedule
                  @user.schedule
                else
                  # create schedule if one doesn't exist
                  @user.schedule = Schedule.create
                end
  end

  def build_days_array(params)
    days = []
    %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].each_with_index do |d, i|
      days << i if params[d]
    end
    days
  end
end
