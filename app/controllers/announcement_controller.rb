# AnnouncementController: functions for announcemnt manuipulation
# referenced https://www.codecademy.com/courses/learn-rails/lessons/one-model/exercises/one-model-view?action=lesson_resume
# referenced https://www.twilio.com/blog/2012/02/adding-twilio-sms-messaging-to-your-rails-app.html
class AnnouncementController < ApplicationController
  include AnnouncementHelper
  before_action :coach?, except: %i[index show]

  def index
    @userlist = [User.find_by(first_name: 'Jack').first_name]
    @user = User.where(first_name: @userlist)
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
    @name = params[:name]
    if User.exists?(first_name: 'Jack')
      @userlist =  [User.find_by(first_name: 'john').first_name]
    else
    @announcement = Announcement.new(announcement_params)
    if @announcement.sms && @announcement.save
      send_text_message(@announcement.title, @announcement.content)
      announcement_success
    elsif @announcement.save
      announcement_success
    else
      redirect_to '/announcement'
      flash[:alert] = 'Please select a send type before submitting announcement'
    end
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

  def get
    @name = parmas[:fname]
    if User.exists?(first_name: @name)
      @userlist = @userlist + [User.find_by(first_name: @name).first_name]
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:email, :sms, :title, :content)
  end

  def announcement_success
    @announcement.sender = [current_user.first_name, current_user.last_name].join(' ')
    @announcement.save
    @announcement.scopify(params[:roles])
    #@announcement.scopify(params[:users])

    redirect_to '/announcement'
    flash[:success] = 'Announcement sent'
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
