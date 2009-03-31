class NoFuzzGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.template "model.rb", "app/models/#{class_name.underscore.downcase}_trigram.rb", {
        :assigns => local_assigns
      }

      m.migration_template "migration.rb", "db/migrate", {
        :assigns => local_assigns,
        :migration_file_name => local_assigns[:migration_class_name].underscore.downcase
      }
    end
  end

  private
  def local_custom_name
    class_name.underscore.downcase
  end

  def gracefully_pluralize(str)
    str.pluralize! if ActiveRecord::Base.pluralize_table_names
    str
  end

  def local_assigns
    returning(assigns = {}) do
      assigns[:class_name] = local_custom_name.classify
      assigns[:migration_class_name] = "CreateTrigramsTableFor#{assigns[:class_name]}"
      assigns[:table_name] = gracefully_pluralize(local_custom_name + "_trigram")
      assigns[:foreign_key] = (class_name.underscore.downcase + "_id")
    end
  end
end
