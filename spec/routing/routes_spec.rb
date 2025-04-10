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
        expect(post: '/api/v1/authentication/register').to route_to('api/v1/authentication/register#create',
                                                                    format: :json)
      end
    end

    describe 'google' do
      it 'routes to api/v1/authentication/google#create' do
        expect(post: '/api/v1/authentication/google').to route_to('api/v1/authentication/google#create',
                                                                  format: :json)
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

  describe 'users' do
    it 'routes to api/v1/users#confirm_email' do
      expect(post: '/api/v1/users/confirm_email').to route_to('api/v1/users/confirm_email#create', format: :json)
    end

    it 'routes to api/v1/users#resend_email_confirmation' do
      expect(post: '/api/v1/users/resend_email_confirmation').to route_to('api/v1/users/resend_email_confirmation#create', format: :json)
    end

    it 'routes to api/v1/users#me' do
      expect(get: '/api/v1/users/me').to route_to('api/v1/users/me#show', format: :json)
    end
  end

  describe 'trails' do
    it 'routes to api/v1/trails#index' do
      expect(get: '/api/v1/trails').to route_to('api/v1/trails#index', format: :json)
    end

    it 'routes to api/v1/trails#show' do
      expect(get: '/api/v1/trails/1').to route_to('api/v1/trails#show', id: '1', format: :json)
    end

    it 'routes to api/v1/trails#destroy' do
      expect(delete: '/api/v1/trails/1').to route_to('api/v1/trails#destroy', id: '1', format: :json)
    end
  end
end
