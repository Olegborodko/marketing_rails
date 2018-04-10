Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Api => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
