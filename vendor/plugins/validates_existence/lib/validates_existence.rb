module ActiveRecord
  module Validations

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      # The validates_existence_of validator checks that a foreign key in a belongs_to
      # association points to an exisiting record. If :allow_nil => true, then the key
      # itself may be nil. A non-nil key requires that the foreign object must exist.
      # Works with polymorphic belongs_to.
      def validates_existence_of(*attr_names)
        configuration = { :message => "does not exist", :on => :save }
        configuration.update(attr_names.extract_options!)

        validates_each(attr_names,configuration) do |record, attr_name, value|
          assoc_name = attr_name.to_s.sub(/_id/, '').to_sym
          unless (assoc = reflect_on_association(assoc_name)) && assoc.macro == :belongs_to
            raise ArgumentError, "Cannot validate existence of :#{attr_name} because it is not a belongs_to association."
          end
          fk_value = record.__send__(assoc.primary_key_name)
          unless fk_value.nil? && configuration[:allow_nil]
            if (foreign_type = assoc.options[:foreign_type]) # polymorphic
              foreign_type_value = record[assoc.options[:foreign_type]]
              if !foreign_type_value.blank?
                assoc_class = foreign_type_value.constantize
              else
                record.errors.add(attr_name, configuration[:message])
                next
              end
            else # not polymorphic
              assoc_class = assoc.klass
            end
            record.errors.add(attr_name, configuration[:message]) unless assoc_class && assoc_class.exists?(fk_value)
          end
        end
      end

    end # ClassMethods

  end
end
