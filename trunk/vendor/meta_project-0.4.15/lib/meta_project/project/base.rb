module MetaProject
  module Project
    class Base
      attr_reader :scm, :scm_web, :tracker, :name, :home_page
    end
    
    class ProjectException < Exception; end
  end
end