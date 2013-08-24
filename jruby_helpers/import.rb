module JrubyHelpers
  module Import
    def import_java(what_to_import)
      if what_to_import.is_a?(String)
        import_array([what_to_import])
      else
        import_array(what_to_import.to_a)
      end
    end

    private

    def import_array(java_class_names)
      java_class_names.each do |java_class_name|
        import_java_class(java_class_name)
      end
    end

    def import_java_class(java_class_name)
      ruby_class_name, ruby_namespace = decode_java_class_name(java_class_name)
      create_ruby_class_constant(ruby_class_name, ruby_namespace)
    end

    def decode_java_class_name(java_class_name)
      components = java_class_name.split('.')
      ruby_class_name = components.pop
      ruby_namespace = 'Java::' + components.map{|c| c.capitalize}.join
      [ruby_class_name, ruby_namespace]
    end

    def create_ruby_class_constant(ruby_class_name, ruby_namespace)
      class_for_constant.class_eval "#{ruby_class_name} = #{ruby_namespace}::#{ruby_class_name}"
    end

    def class_for_constant
      if self.is_a?(Class)
        self
      else
        self.class
      end
    end
  end
end

