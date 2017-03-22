module Bitmovin
  module ChildCollection
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def child_collection(name, path, parameters, klass)
        define_method("load_#{name}") do
          vars = parameters.map { |p| instance_variable_get("@#{p}") }
          url = path % vars
          response = Bitmovin.client.get(url)

          result(response)["items"].map do |item| 
            p = vars + [item]
            klass.new(*p)
          end
        end
        define_method(name) do
          if !persisted?
            raise "#{self.class.name.demodulize} is not persisted yet - can't load #{name}"
          end
          if instance_variable_get("@#{name}").nil?
            items = send("load_#{name}")
            instance_variable_set("@#{name}", items)
          end
          instance_variable_get("@#{name}")
        end

        define_method("build_#{ActiveSupport::Inflector.singularize(name)}") do |hash = {}|
          instance_vars = parameters.map { |p| instance_variable_get("@#{p}") }
          if !persisted?
            raise "Period is not persisted yet - can't create #{ActiveSupport::Inflector.singularize(name)}"
          end
          instance_vars << hash
          klass.new(*instance_vars)
        end
      end
    end
  end
end
