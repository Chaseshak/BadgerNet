# AnnouncementController: functions for announcemnt manuipulation
# referenced https://www.codecademy.com/courses/learn-rails/lessons/one-model/exercises/one-model-view?action=lesson_resume
class AnnouncementController < ApplicationController
  include AnnouncementHelper
  before_action :authenticate_user!
  before_action :coach?, except: [:index]

  def index
    @announcements = Announcement.all
  end

  def new
    @announcement = Announcement.new
  end

  def create
    # byebug
    @announcement = Announcement.new(announcement_params)
    if @announcement.sms && @announcement.save
      send_text_message(@announcement.content)
      redirect_to '/announcement'
    elsif @announcement.save
      redirect_to '/announcement'
    else
      render 'new'
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:email, :sms, :title, :content)
  end
end
