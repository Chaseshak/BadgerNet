# AnnouncementController: functions for announcemnt manuipulation
# referenced https://www.codecademy.com/courses/learn-rails/lessons/one-model/exercises/one-model-view?action=lesson_resume
# referenced https://www.twilio.com/blog/2012/02/adding-twilio-sms-messaging-to-your-rails-app.html
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
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(announcement_params)
    if params[:roles]
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
    @announcement = Announcement.find(params[:id])
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

  def announcement_fail
    redirect_to '/announcement'
    flash[:alert] = 'Did not enter a vaild user or role'
  end

  def announcement_fail_no_send_method
    redirect_to '/announcement'
    flash[:alert] = 'Please select a send type before submitting announcement'
  end

  # rubocop:disable MethodLength
  def role_announcement
    if @announcement.sms && @announcement.email
      send_text_message(@announcement.title, @announcement.content)
      send_email
      announcement_success
    elsif @announcement.email
      send_email
      announcement_success
    elsif @announcement.sms
      send_text_message(@announcement.title, @announcement.content)
      announcement_success
    else
      announcement_fail_no_send_method
    end
  end

  def send_email
    sent = false
    User.all.each do |u|
      params[:roles].each do |r|
        next unless u.roles.include?(Role.find(r)) && (sent == false)
        CommentMailer.new_comment(u, @announcement.title, @announcement.content,
                                  current_user).deliver_now
        sent = true
      end
    end
  end

  def send_text_message(subject, words)
    number_to_send_to = '2066180749' # "params[:number_to_send_to]"

    twilio_sid = 'ACc17e1968205992bb82bdb0ba8de37732' # this is public
    twilio_token = ENV['TWILIO_TOKEN'] # private, environment variable
    twilio_phone_number = '2062078212'

    @twilio_client = Twilio::REST::Client.new(twilio_sid, twilio_token)

    @twilio_client.messages.create(
      from: "+1#{twilio_phone_number}",
      to: number_to_send_to,
      body: subject + ' - ' + words
    )
  end
end
