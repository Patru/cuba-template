# encoding: UTF-8
require_relative 'admin'

module Views
  module Admin
    module Admin
      class Edit < Admin
        def page_title
          "Edit admin #{admin.name}"
        end

        def body_content
          form(admin.show_path, 'Save', 'put')
        end
      end
    end
  end
end
