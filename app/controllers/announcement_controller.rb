# AnnouncementController: functions for announcemnt manuipulation
# referenced https://www.codecademy.com/courses/learn-rails/lessons/one-model/exercises/one-model-view?action=lesson_resume
class AnnouncementController < ApplicationController
  include AnnouncementHelper
  before_action :coach?, except: %i[index show]

  def index
    @announcements = Announcement.all
    @announcement = Announcement.new
    if current_user.has_role? :coach
      render 'admin_index'
    else
      render
    end
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(announcement_params)
    if @announcement.sms && @announcement.save
      send_text_message(@announcement.content)
      announcement_success
    elsif @announcement.save
      announcement_success
    else
      redirect_to '/announcement'
      flash[:alert] = 'Please select a send type before submitting announcement'
    end
  end

  def destroy
    begin
      Announcement.find(params[:id]).destroy
      flash[:success] = 'Announcement deleted'
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Could not find this announcement'
    end
    redirect_to action: 'index'
  end

  def show
    @announcement = Announcement.find(params[:id])
    return unless @announcement.nil?
    @announcements = Announcement.all
    flash[:alert] = 'Announcement not found'
    render 'index'
  end

  private

  def announcement_params
    params.require(:announcement).permit(:email, :sms, :title, :content)
  end

  def announcement_success
    redirect_to '/announcement'
    flash[:success] = 'Announcement sent'
  end
end
