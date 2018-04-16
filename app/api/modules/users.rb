module Modules
  class Users < Grape::API
    prefix 'api'
    format :json

    helpers do
      include UsersHelper
    end

    before do
      @current_user = current_user('Token')
    end

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
          token = token_encode_for_verification(random_string[:full], user.email)
          user.update_column(:token, random_string[:part])
          {token: token, email: user.email}
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
      end
      post :logout do
        if @current_user
          @current_user.update_column(:token, nil)
          return {message: 'success'}
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
      end
      post :verification do
        if @current_user
          new_t = new_token(@current_user)
          if new_t
            return {token: new_t[:token], email: @current_user[:email]}
          end
        end
        status 406
        {error: 'Data not correct'}
      end


    end
  end
end