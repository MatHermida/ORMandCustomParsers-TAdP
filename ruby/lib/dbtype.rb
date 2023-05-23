require_relative './validations'

module ComplexType
    def validate_complex!(value, attr_name)
        raise AttrNotCorrectTypeError.new(attr_name) unless value.is_a?(@type)
        if (!@validations.nil?)
            value.class.persistent_attributes.each do |key, db_type|
                if (key != :id)
                    db_type.validate!(value.attributes_hash, key)
                end
            end
        end
    end
end

module SimpleType
    def validate_simple!(value, attr_name)
        raise AttrNotCorrectTypeError.new(attr_name) unless value.is_a?(@type)
        if (!@validations.nil?)
            @validations.each do |validator|
                validator.validate!(value)
            end
        end
    end

    def save!(hash_all_attr, attr_name, instance)
        hash_all_attr
    end
end

module DbType
    attr_accessor :name, :type, :validations, :default
    def initialize(type, description)
        @name = description[:named]
        @type = type
        @default = description[:default]
        @validations = description.reduce([]) { |result, (validation, value)|
            if (validation == :no_blank)
                result << NoBlankValidation.new
            end
            if (validation == :from)
                result << FromValidation.new(value)
            end
            if (validation == :to)
                result << ToValidation.new(value)
            end
            if (validation == :validate)
                result << ValidateValidation.new(value)
            end
            result
        }
    end

    def validate_default!(hash_all_attr, attr_name)
        if hash_all_attr[attr_name].nil? && !@default.nil? then hash_all_attr[attr_name] = @default end
    end
end

class OneComplexDbType
    include DbType
    include ComplexType
    def validate!(hash_all_attr, attr_name)
        validate_default!(hash_all_attr, attr_name)
        validate_complex!(hash_all_attr[attr_name], attr_name)
        hash_all_attr
    end

    def save!(hash_all_attr, attr_name, instance)
        hash_all_attr[attr_name] = hash_all_attr[attr_name].save!
        hash_all_attr
    end

    def refresh!(saved_value, attr_name, instance)
        instance.send(attr_name.to_s + "=", @type.find_by_id(saved_value).first)
    end
end

class ManyComplexDbType
    include DbType
    include ComplexType
    def validate!(hash_all_attr, attr_name)
        validate_default!(hash_all_attr, attr_name)
        hash_all_attr[attr_name].each do |value|
            validate_complex!(value, attr_name)
        end
        hash_all_attr
    end

    def save!(hash_all_attr, attr_name, instance)
        hash_all_attr[:id] ||= SecureRandom.uuid
        hash_all_attr[attr_name].each do |value|
            id_complex = value.save!
            intermediate_table(instance.class.name).insert({ instance.class.name.to_sym => hash_all_attr[:id], self.class.name.to_sym  => id_complex })
        end
        hash_all_attr.except(attr_name)
    end

    def refresh!(saved_value, attr_name, instance)
        ids = intermediate_table(instance.class.name).entries.select {|entry| entry[instance.class.name.to_sym] == instance.id}
        values = ids.reduce([]) { |result, entry|
            result << @type.find_by_id(entry[self.class.name.to_sym]).first
            result
        }
        instance.send(attr_name.to_s + "=", values)
    end

    def intermediate_table(class_name)
        TADB::DB.table(self.class.name + class_name)
    end
end

class OneSimpleDbType
    include DbType
    include SimpleType
    def validate!(hash_all_attr, attr_name)
        validate_default!(hash_all_attr, attr_name)
        validate_simple!(hash_all_attr[attr_name], attr_name)
        hash_all_attr
    end

    def refresh!(saved_value, attr_name, instance)
        instance.send(attr_name.to_s + "=", saved_value)
    end
end

class ManySimpleDbType
    include DbType
    include SimpleType
    def validate!(hash_all_attr, attr_name)
        validate_default!(hash_all_attr, attr_name)
        hash_all_attr[attr_name].each do |value|
            validate_simple!(value, attr_name)
        end
        hash_all_attr
    end

    def refresh!(saved_value, attr_name, instance)
        instance.send(attr_name.to_s + "=", saved_value)
    end
end