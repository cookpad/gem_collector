require 'rails_helper'

RSpec.describe 'repositories API' do
  describe 'GET /api/v1/repositories' do
    let!(:repo1) { FactoryBot.create(:repository) }
    let!(:repo2) { FactoryBot.create(:repository) }

    it 'returns repositories', autodoc: true do
      get '/api/v1/repositories'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match_array([repo1.as_json, repo2.as_json])
    end
  end

  describe 'GET /api/v1/repositories/:id' do
    let(:repo) { FactoryBot.create(:repository) }

    before do
      FactoryBot.create(:repository_gem, repository_id: repo.id, name: 'gem1', version: '0.1.0')
      FactoryBot.create(:repository_gem, repository_id: repo.id, name: 'gem2', version: '0.2.0')
      FactoryBot.create(:repository_gem, repository_id: repo.id, name: 'gem3', version: '0.3.0', path: 'another/Gemfile.lock')
    end

    it 'returns repository gems', autodoc: true do
      get "/api/v1/repositories/#{repo.id}"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match({
        'gemfiles' => match_array([
          {
            'path' => 'Gemfile.lock',
            'gems' => match_array([
              { 'name' => 'gem1', 'version' => '0.1.0', 'version_point' => a_kind_of(Float) },
              { 'name' => 'gem2', 'version' => '0.2.0', 'version_point' => a_kind_of(Float) },
            ]),
          },
          {
            'path' => 'another/Gemfile.lock',
            'gems' => [
              { 'name' => 'gem3', 'version' => '0.3.0', 'version_point' => a_kind_of(Float) },
            ],
          },
        ]),
      })
    end
  end
end
