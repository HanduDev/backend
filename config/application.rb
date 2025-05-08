require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    config.load_defaults 8.0
    config.factory_bot.definition_file_paths = ["spec/factories"]

    config.autoload_lib(ignore: %w[assets tasks])
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.time_zone = 'Brasilia'
    config.i18n.locale = :'pt-BR'
    config.i18n.default_locale = :'pt-BR'
    config.i18n.available_locales = ['pt-BR', :en]
    config.i18n.fallbacks = [:en]
    config.active_job.queue_adapter = :sidekiq

    config.api_only = true
  end
end
