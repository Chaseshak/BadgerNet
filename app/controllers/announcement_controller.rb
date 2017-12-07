# AnnouncementController: functions for announcemnt manuipulation
# referenced https://www.codecademy.com/courses/learn-rails/lessons/one-model/exercises/one-model-view?action=lesson_resume
class AnnouncementController < ApplicationController
  include AnnouncementHelper
  before_action :coach?, except: %i[index show]

  def index
    @announcements = Announcement.scoped(current_user)
    @announcement = Announcement.new
    if current_user.has_role? :coach
      render 'admin_index'
    else
      render
    end
  end

  def new
    @ann = Announcement.new
  end

  def create
    @fname = params[:fname]
    @lname = params[:lname]
    @ann = Announcement.new(announcement_params)
    if User.exists?(first_name: @fname, last_name: @lname)
      user_announcement
    elsif params[:roles]
      role_announcement
    else
      announcement_fail
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
    @ann = Announcement.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Could not find this announcement'
    render 'index'
  end

  private

  def announcement_params
    params.require(:announcement).permit(:email, :sms, :title, :content)
  end

  def announcement_success
    @announcement.sender = [current_user.first_name, current_user.last_name].join(' ')
    @announcement.save
    @announcement.scopify(params[:roles])
    redirect_to '/announcement'
    flash[:success] = 'Announcement sent'
  end

  def announcement_success_personal
    redirect_to '/announcement'
    flash[:success] = 'Personal announcement sent'
  end

  def announcement_fail
    redirect_to '/announcement'
    flash[:alert] = 'Did not enter a vaild user or role'
  end

  def user_announcement
    @to = User.find_by(first_name: @fname, last_name: @lname)
    if @ann.sms && @ann.email
      CommentMailer.new_comment(@to, @ann.title, @ann.content, current_user).deliver_now
      send_text_message(@announcement.content)
    elsif @announcement.email
      CommentMailer.new_comment(@to, @ann.title, @ann.content, current_user).deliver_now
    elsif @ann.sms
      send_text_message(@ann.content)
    end
    announcement_success_personal
  end

  def role_announcement
    if @ann.sms && @ann.save
      send_text_message(@ann.content)
      announcement_success
    elsif @ann.save
      role_announcements
      announcement_success
    else
      redirect_to '/announcement'
      flash[:alert] = 'Please select a send type before submitting announcement'
    end
  end

  def role_announcements
    User.all.each do |u|
      sent = false
      params[:roles].each do |r|
        if u.roles.include?(Role.find(r)) && sent == false
          sent = true
          CommentMailer.new_comment(u, @ann.title, @ann.content, current_user).deliver_now
        end
      end
    end
  end
end
