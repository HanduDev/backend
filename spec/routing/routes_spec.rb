# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Routes', type: :routing do
  describe 'authentication' do
    describe '/api/v1/authentication/login' do
      it 'routes to api/v1/authentication/login#create' do
        expect(post: '/api/v1/authentication/login').to route_to('api/v1/authentication/login#create', format: :json)
      end
    end

    describe 'register' do
      it 'routes to api/v1/authentication/register#create' do
        expect(post: '/api/v1/authentication/register').to route_to('api/v1/authentication/register#create', format: :json)
      end
    end
  end

  describe 'text' do
    it 'routes to api/v1/translate_text#create' do
      expect(post: '/api/v1/translate_text').to route_to('api/v1/translate_text#create', format: :json)
    end
  end

  describe 'languages' do
    it 'routes to api/v1/languages#index' do
      expect(get: '/api/v1/languages').to route_to('api/v1/languages#index', format: :json)
    end
  end
end
