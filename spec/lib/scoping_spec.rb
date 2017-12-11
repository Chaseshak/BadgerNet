require 'rails_helper'
require Rails.root.join('lib', 'scoping.rb')

describe Scoping::Retrieve do
  context 'scoped(user, options)' do
    let(:coach) { create(:coach_user) }
    let(:athlete) { create(:athlete_user) }
    let(:role1) { create(:role) }
    let(:role2) { create(:role) }
    let!(:document1) { create(:document, created_at: '2017-11-29 23:20:54') }
    let!(:document2) { create(:document, created_at: '2017-11-29 23:20:55') }

    context 'user is an athlete' do
      it 'returns only the resources the user has access to when they are an athlete' do
        Scope.create(resource: 'Document', resource_id: document1.id, role_id: role1.id)
        athlete.add_role role1.name
        result = Document.scoped(athlete)
        expect(result.count).to eq(1)
        expect(result.first).to eq(document1)
      end

      it 'returns limited number of resources with the :limit hash option' do
        Scope.create(resource: 'Document', resource_id: document1.id, role_id: role1.id)
        Scope.create(resource: 'Document', resource_id: document2.id, role_id: role1.id)
        athlete.add_role role1.name
        result = Document.scoped(athlete, limit: 1)
        expect(result.count).to eq(1)
        expect(result.first).to eq(document2) # since more recent
      end

      it 'returns the limited and offset resources when both options passed' do
        Scope.create(resource: 'Document', resource_id: document1.id, role_id: role1.id)
        Scope.create(resource: 'Document', resource_id: document2.id, role_id: role1.id)
        athlete.add_role role1.name
        result = Document.scoped(athlete, limit: 1, offset: 1)
        expect(result.count).to eq(1)
        expect(result.first).to eq(document1) # since less recent
      end
    end

    context 'user is a coach' do
      it 'returns all resources' do
        result = Document.scoped(coach)
        expect(result.count).to eq(Document.count)
        expect(result.first).to eq(document2)
        expect(result.second).to eq(document1)
      end

      it 'returns limited number of resources with the :limit hash option' do
        result = Document.scoped(coach, limit: 1)
        expect(result.count).to eq(1)
        expect(result.first).to eq(document2)
      end

      it 'returns the limited and offset resources when both options passed' do
        result = Document.scoped(coach, limit: 1, offset: 1)
        expect(result.count).to eq(1)
        expect(result.first).to eq(document1)
      end
    end
  end

  context 'raw_sql(table_name, user)' do
    let(:athlete) { create(:athlete_user) }
    it 'returns the correct raw sql' do
      correct_sql = 'SELECT DISTINCT(documents.*) FROM users '\
      'INNER JOIN users_roles ON users.id = users_roles.user_id '\
      'INNER JOIN scopes ON scopes.role_id = users_roles.role_id '\
      'INNER JOIN documents ON documents.id = scopes.resource_id '\
      "WHERE users.id = #{athlete.id} AND scopes.resource = 'Document' "\
      'ORDER BY created_at DESC '
      expect(Document.raw_sql('documents', athlete)).to eq(correct_sql)
    end
  end
end

describe Scoping::Scopey do
  context 'scopify(roles)' do
    let!(:role1) { create(:role) }
    let!(:role2) { create(:role) }
    let!(:doc) { create(:document) }

    it 'adds the selected roles only when roles is defined' do
      doc.scopify([role1.id])
      expect(Scope.where(resource_id: doc.id).first.role_id).to eq(role1.id)
    end

    it 'adds all the roles when no roles are given' do
      doc.scopify(nil)
      expect(Scope.where(resource_id: doc.id).count).to eq(Role.count)
    end
  end
end
