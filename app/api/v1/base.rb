require 'grape-swagger'

module V1
  class Base < Grape::API

    helpers ::Helpers::DefaultsHelpers
    include V1::ExceptionsHandler

    # Endpoints
    mount V1::Prizes
    mount V1::Entries
    mount V1::Winners
    mount V1::Users
    route :any, '*path' do
      render_error!('not_found_error', 'Path not found', 404)
    end

    # Documentation
    add_swagger_documentation \
      api_version: 'v1',
      markdown: true,
      hide_documentation_path: true,
      base_path: '/api',
      add_version: true,
      consumes: 'multipart/form-data',
      info: {
        title: 'Oprah',
        description: 'You get a prize. yOU GET A prize ! EVERYONE GETS a prize !',
        contact_name: 'Kat Padilla',
        contact_email: 'hello@katpadi.ph',
        contact_url: 'http://katpadi.ph'
      }
  end
end
