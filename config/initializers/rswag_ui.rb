Rswag::Ui.configure do |c|
  c.swagger_endpoint '/api-docs/api/swagger.yaml', 'API V1 Docs'

  c.basic_auth_enabled = true
  c.basic_auth_credentials 'sst', '123'
end
