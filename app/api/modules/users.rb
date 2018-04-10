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
          token = token_encode_for_take(Time.now)
          user.update_column(:token, token)
          {token: token, email: user.email}
        else
          {message: 'error'}
        end
      end



    end
  end
end