Rails.application.routes.draw do
  mount Api::Root => '/'
  mount GrapeSwaggerRails::Engine => '/documentation'
end
