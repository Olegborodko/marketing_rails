module Modules
  class Admin < Grape::API
    prefix 'api'
    format :json

    helpers do
      include UsersHelper
    end

    before do
      @current_user = current_user('Token')
      if @current_user
        @admin_correct = admin?(@current_user[:email])
      end
    end

    resource :admin do
      desc 'All users', {
      # is_array: true,
      success: { code: 201 }, #, model: Entities::UserCreate },
      failure: [{ code: 406 }]
      }
      params do
        optional :token, type: String, documentation: { param_type: 'header' }
      end
      post :users do
        if @admin_correct
          new_token = new_token(@current_user)
          users = User.order(:email)
          return {token: new_token[:token], email: new_token[:email], users: users}
        end
        status 406
        {error: 'Data not correct'}
      end

      desc 'User add', {
      # is_array: true,
      success: { code: 201 }, #, model: Entities::UserCreate },
      failure: [{ code: 406 }, {code: 400}]
      }
      params do
        optional :token, type: String, documentation: { param_type: 'header' }
        requires :email, allow_blank: false, regexp: /.+@.+/, desc: 'user email'
        requires :password, type: String, desc: 'user password'
        optional :name, type: String, desc: 'user name'
      end
      post :user_add do
        if @admin_correct
          user_new = User.new(name: params[:name],
                              email: params[:email],
                              password: params[:password])
          if user_new.save
            new_token = new_token(@current_user)
            return {message: 'success',
                    token: new_token[:token],
                    email: new_token[:email]
            }
          end
        end
        status 406
        {error: 'Data not correct'}
      end

      desc 'User delete', {
      # is_array: true,
      success: { code: 201 }, #, model: Entities::UserCreate },
      failure: [{ code: 406 }, {code: 400}]
      }
      params do
        optional :token, type: String, documentation: { param_type: 'header' }
        requires :email, allow_blank: false, regexp: /.+@.+/, desc: 'user email'
      end
      delete :user_delete do
        if @admin_correct
          user = User.find_by email: params[:email]
          if user && user.destroy
            new_token = new_token(@current_user)
            return {message: 'success',
                    token: new_token[:token],
                    email: new_token[:email]
            }
          end
        end
        status 406
        {error: 'Data not correct'}
      end

    end
  end
end