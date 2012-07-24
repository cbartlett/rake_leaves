require 'rake_leaves'
require 'rails'

module RakeLeaves
  class Railtie < Rails::Railtie
    railtie_name :rake_leaves

    rake_tasks do
      load 'tasks/rake_leaves.rake'
    end
  end
end
