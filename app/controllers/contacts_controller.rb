# contacts controller will control contacts
class ContactsController < ApplicationController
  def index
    @users = User.all
    if current_user.coach?
      @roles = Role.non_permissions_roles
      render 'admin_index'
    else
      render
    end
  end

  def update
    @u = User.find(params[:id])
    @r = Role.find(params[:role])
    update_role
    redirect_to action: 'index'
  end

  def create
    role = Role.where('name ILIKE ?', params[:name]).first
    if role.present? && !role.archived # if archived, un-archive
      flash[:alert] = "Team '#{role.name}' already exists!"
    else
      update_or_create_role(role)
    end
    redirect_to action: 'index'
  end

  def destroy
    flash[:alert] = 'Must select at least one team to delete!' unless destroy_roles
    redirect_to action: 'index'
  end

  private

  def destroy_roles
    return false if params[:roles].blank? || params[:roles].empty?
    flash[:success] = ''
    params[:roles].each_with_index do |id, i|
      to_archive = Role.find(id)
      to_archive.archived = true
      to_archive.save
      flash[:success] += "Successfully removed team(s): #{to_archive.name}" if i.zero?
      flash[:success] += ", #{to_archive.name}" unless i.zero?
    end
    true
  end

  def create_success_message
    flash[:success] = "Successfully added new team '#{params[:name]}'"
  end

  def update_or_create_role(role)
    if role.present? && role.archived
      role.archived = false
      role.save
    else
      Role.create(name: params[:name].downcase)
    end
    create_success_message
  end

  def update_role
    if !@u.roles.include?(@r)
      @u.add_role(@r.name)
      Scope.backfill_event_scope(@u, @r)
      flash[:success] = "Successfully added #{@u.first_name} to #{@r.cap_name} team!"
    else
      @u.delete_role @r.name
      Scope.remove_event_scope(@u, @r)
      flash[:success] = "Successfully removed #{@u.first_name} from #{@r.cap_name} team!"
    end
  end
end
