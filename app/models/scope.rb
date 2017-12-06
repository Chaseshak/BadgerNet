# Scope manages the scope of resources based on roles
class Scope < ApplicationRecord
  belongs_to :user
end
