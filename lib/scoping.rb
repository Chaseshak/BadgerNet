# Scoping defines helper functions for managing scoped resources
module Scoping
  # Retrieve handles retreiving scoped resources
  module Retrieve
    def scoped(user, options = {})
      return coach_results(options) if user.has_role? :coach
      table_name = name.downcase + 's'
      records = ActiveRecord::Base.connection.execute(sql(table_name, user, options))
      fields = records.fields
      records.values.map { |vals| name.constantize.instantiate(Hash[fields.zip(vals)]) }
    end

    def coach_results(options)
      if options[:limit] && options[:offset]
        name.constantize.all.limit(options[:limit]).offset(options[:offset])
            .order(created_at: :desc)
      elsif options[:limit]
        name.constantize.all.limit(options[:limit]).order(created_at: :desc)
      else
        name.constantize.all.order(created_at: :desc)
      end
    end

    def sql(table_name, user, options)
      if options[:limit] && options[:offset]
        raw_sql(table_name, user) + " LIMIT #{options[:limit]} OFFSET #{options[:offset]}"
      elsif options[:limit]
        raw_sql(table_name, user) + " LIMIT #{options[:limit]}"
      else
        raw_sql(table_name, user)
      end
    end

    def raw_sql(table_name, user)
      "SELECT DISTINCT(#{table_name}.*) FROM users "\
      'INNER JOIN users_roles ON users.id = users_roles.user_id '\
      'INNER JOIN scopes ON scopes.role_id = users_roles.role_id '\
      "INNER JOIN #{table_name} ON #{table_name}.id = scopes.resource_id "\
      "WHERE users.id = #{user.id} AND scopes.resource = '#{name.capitalize}' "\
      'ORDER BY created_at DESC '
    end
  end

  # Scopify module adds scopes to resources
  module Scopey
    def scopify(roles)
      resource_name = self.class.name
      if roles
        roles.each do |role_id|
          Scope.create(resource: resource_name, resource_id: id, role_id: role_id)
        end
      else
        Role.all.each do |role|
          Scope.create(resource: resource_name, resource_id: id, role_id: role.id)
        end
      end
    end
  end
end
