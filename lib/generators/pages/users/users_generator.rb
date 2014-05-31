require 'rails/generators'

module Pages
  module Generators
    class UsersGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Create pages to accompany a User model."

      def create_pages
        copy_file 'users/_user.html.erb', 'app/views/users/_user.html.erb'
        copy_file 'users/index.html.erb', 'app/views/users/index.html.erb'
        copy_file 'users/show.html.erb', 'app/views/users/show.html.erb'
        generate 'pages:home -f'
        copy_file 'visitors/index.html.erb', 'app/views/visitors/index.html.erb'
      end

      def create_devise_pages
        return unless File.exists?('config/initializers/devise.rb')
        copy_file 'devise/users_controller.rb', 'app/controllers/users_controller.rb'
        route = '  resources :users'
        inject_into_file 'config/routes.rb', route + "\n", :after => "devise_for :users\n"
      end

      def create_omniauth_pages
        return unless File.exists?('config/initializers/omniauth.rb')
        copy_file 'users/edit.html.erb', 'app/views/users/edit.html.erb'
        copy_file 'omniauth/users_controller.rb', 'app/controllers/users_controller.rb'
        route = '  resources :users, :only => [:index, :show, :edit, :update ]'
        inject_into_file 'config/routes.rb', route + "\n", :after => "root :to => \"visitors#index\"\n"
        prepend_file 'app/views/users/_user.html.erb', "<td><%= link_to user.name, user %></td>\n"
        inject_into_file 'app/views/users/show.html.erb', "\n<p>Name: <%= @user.name if @user.name %></p>", :before => "\n<p>Email"
      end

      def add_devise_name_field
        return unless File.exists?('config/initializers/devise.rb')
        if Object.const_defined?('User')
          if User.column_names.include? 'name'
            permitted = File.read(find_in_source_paths('devise/permitted_parameters.rb'))
            inject_into_file 'app/controllers/application_controller.rb', permitted + "\n", :after => "protect_from_forgery with: :exception\n"
            prepend_file 'app/views/users/_user.html.erb', "<td><%= link_to user.name, user %></td>\n"
            inject_into_file 'app/views/users/show.html.erb', "\n<p>Name: <%= @user.name if @user.name %></p>", :before => "\n<p>Email"
          end
        end
      end

      def add_devise_tests
        return unless File.exists?('config/initializers/devise.rb')
        return unless File.exists?('spec/spec_helper.rb')
        copy_file 'spec/factories/users.rb', 'spec/factories/users.rb'
        copy_file 'spec/features/users/sign_in_spec.rb', 'spec/features/users/sign_in_spec.rb'
        copy_file 'spec/features/users/sign_out_spec.rb', 'spec/features/users/sign_out_spec.rb'
        copy_file 'spec/features/users/user_delete_spec.rb', 'spec/features/users/user_delete_spec.rb'
        copy_file 'spec/features/users/user_edit_spec.rb', 'spec/features/users/user_edit_spec.rb'
        copy_file 'spec/features/users/user_index_spec.rb', 'spec/features/users/user_index_spec.rb'
        copy_file 'spec/features/users/user_show_spec.rb', 'spec/features/users/user_show_spec.rb'
        copy_file 'spec/features/visitors/sign_up_spec.rb', 'spec/features/visitors/sign_up_spec.rb'
        copy_file 'spec/models/user_spec.rb', 'spec/models/user_spec.rb'
        copy_file 'spec/support/helpers/session_helpers.rb', 'spec/support/helpers/session_helpers.rb'
        copy_file 'spec/support/helpers.rb', 'spec/support/helpers.rb'
      end

    end
  end
end
