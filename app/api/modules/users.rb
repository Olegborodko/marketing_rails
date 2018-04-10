module Modules
  class Users < Grape::API
    prefix 'api'
    format :json

    # helpers do
    #   include SessionHelper
    #   include UserHelpers
    # end

    # before do
    #   @current_user = get_user_from_token(users_token)
    # end

    # POST api/users
    resource :users do
      desc 'User log in', {
      # is_array: true,
      # success: { code: 201, model: Entities::UserCreate },
      # failure: [{ code: 406, message: 'Parameters contain errors' }]
      }
      params do
        requires :email, allow_blank: false, regexp: /.+@.+/, desc: 'users email'
        requires :password, type: String, desc: 'users password'
      end
      post :login do
        { message: 'login success' }
      end

    end
  end
end