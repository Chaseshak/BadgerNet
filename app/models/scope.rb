# Scope manages the scope of resources based on roles
class Scope < ApplicationRecord
  belongs_to :role

  def self.remove_event_scope(user, role)
    return unless user.schedule
    user.schedule.event.each do |event|
      scope = Scope.find_by(resource: 'Event', resource_id: event.id, role_id: role.id)
      scope.destroy if scope
    end
  end

  def self.backfill_event_scope(user, role)
    return unless user.schedule
    user.schedule.event.each do |event|
      Scope.create(resource: 'Event', resource_id: event.id, role_id: role.id)
    end
  end
end
