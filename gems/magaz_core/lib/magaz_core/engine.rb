module MagazCore
  class Engine < ::Rails::Engine
    isolate_namespace MagazCore

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer :append_uploaders do |app|
      unless app.root.to_s.match root.to_s
        config.to_prepare do
          Dir.glob(app.root + "app/uploaders/**/*_uploader*.rb").each do |c|
            require_dependency(c)
          end
        end
      end
    end

    initializer :append_constraints do |app|
      unless app.root.to_s.match root.to_s
        config.to_prepare do
          Dir.glob(app.root + "app/constraints/**/*.rb").each do |c|
            require_dependency(c)
          end
        end
      end
    end
    
  end
end