#contacts controller will control contacts
class ContactsController < ApplicationController
  def index
    @users = User.all
  end
end
