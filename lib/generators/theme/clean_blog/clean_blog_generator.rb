require 'rails/generators'

module Theme
  module Generators
    class CleanBlogGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "A Bootstrap HTML starter template (from startbootstrap.com)"

      def create_page
        copy_file 'application.html.erb', 'app/views/layouts/application.html.erb'
        copy_file 'index.html', 'app/views/visitors/index.html.erb'
        copy_file 'clean-blog.css', 'app/assets/stylesheets/clean-blog.css'
      end

    end
  end
end