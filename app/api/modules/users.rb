module Modules
  class Users < Grape::API
    prefix 'api'
    format :json

    helpers do
      include UsersHelper
    end

    # before do
    #   @current_user = get_user_from_token(users_token)
    # end

    # POST api/users
    resource :users do

      desc 'User log in', {
      # is_array: true,
       success: { code: 201 }, #, model: Entities::UserCreate },
       failure: [{ code: 400, message: 'Email is invalid' }]
      }
      params do
        requires :email, allow_blank: false, regexp: /.+@.+/, desc: 'users email'
        requires :password, type: String, desc: 'users password'
      end
      post :login do
        user = User.find_by email: params[:email]
        if user && token_decode(user.password)[0]['password']==params[:password]
          random_string = random_string(50)
          token = token_encode_for_take(random_string[:part])
          user.update_column(:token, token)
          {token: random_string[:full], email: user.email}
        else
          status 406
          {error: 'Error email or password'}
        end
      end

      desc 'User log out', {
      # is_array: true,
      success: { code: 201 } #, model: Entities::UserCreate },
      }
      params do
        optional :token, type: String, documentation: { param_type: 'header' }
        requires :email, type: String, desc: 'users email'
      end
      post :logout do
        user = User.find_by email: params[:email]
        if user && equal_tokens(user, 'Token')
          user.update_column(:token, nil)
          {message: 'success'}
        else
          status 406
          {error: 'Data not correct'}
        end
      end

      desc 'User verification', {
      # is_array: true,
      success: { code: 201 } #, model: Entities::UserCreate },
      }
      params do
        optional :token, type: String, documentation: { param_type: 'header' }
        requires :email, type: String, desc: 'users email'
      end
      post :verification do
        user = User.find_by email: params[:email]
        if user && equal_tokens(user, 'Token')
          random_string = random_string(50)
          token = token_encode_for_take(random_string[:part])
          user.update_column(:token, token)
          {token: random_string[:full], email: user.email}
        else
          status 406
          {error: 'Data not correct'}
        end
      end


    end
  end
end