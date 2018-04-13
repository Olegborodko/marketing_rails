module Modules
  class Admin < Grape::API
    prefix 'api'
    format :json

    helpers do
      include UsersHelper
    end

    resource :admin do

      desc 'All users', {
      # is_array: true,
      success: { code: 201 }, #, model: Entities::UserCreate },
      failure: [{ code: 400 }]
      }
      params do
        optional :token, type: String, documentation: { param_type: 'header' }
      end
      post :users do
        #if

        # user = User.find_by email: params[:email]
        # if user && token_decode(user.password)[0]['password']==params[:password]
        #   random_string = random_string(50)
        #   token = token_encode_for_take(random_string[:part])
        #   user.update_column(:token, token)
        #   {token: random_string[:full], email: user.email}
        # else
        #   status 406
        #   {error: 'Error email or password'}
        # end
      end
    end
  end
end