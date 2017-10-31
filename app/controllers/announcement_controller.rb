# AnnouncementController: functions for announcemnt manuipulation
# referenced https://www.codecademy.com/courses/learn-rails/lessons/one-model/exercises/one-model-view?action=lesson_resume
class AnnouncementController < ApplicationController
  # before_action :authenticate_user
  def index
    @announcements = Announcement.all
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(announcement_params)
    if @announcement.save
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