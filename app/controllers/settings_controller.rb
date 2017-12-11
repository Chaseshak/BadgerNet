# Settings Controller
class SettingsController < ApplicationController
  def index
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:password] != params[:user][:confirm_password]
      flash[:danger] = 'Password Confirmation Does Not Match'
    elsif @user.update_attributes(user_params)
      flash[:success] = 'User Profile Sucessfully Updated'
      bypass_sign_in(@user)
    else
      check_validation_errors
    end
    redirect_to action: 'index'
  end

  private

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name, :phone, :password, :confirm_password)
  end

  def check_validation_errors
    @user.validate!
  rescue ActiveRecord::RecordInvalid => exception
    flash[:danger] = exception.message
  end
end
