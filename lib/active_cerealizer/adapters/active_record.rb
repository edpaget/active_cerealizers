module ActiveCerealizer
  module Adapters
    class ActiveRecord
      def self.fetch(model, link)
        association = model.class.reflect_on_association(link.relation)
        case association.macro
        when :belongs_to
          id = model.send(association.foreign_key).to_s,
          if link.polymorphic?
            [id, model.send(association.foreign_type)]
          else
            id
          end
        when :has_one
          model.send(association.name).try(:id).try(:to_s)
        else
          associated = if model.send(association.name).loaded?
                         model.send(association.name)
                       else
                         model.send(association.name).select(:id)
                       end

          associated.map do |assoc|
            if link.polymorphic?
              [assoc.id.to_s, assoc.class]
            else
              assoc.id.to_s
            end
          end
        end
      end
      
      def self.field_type(model_class, field)
        col = model_class.columns.find{ |col| col.name == field.to_s }
        if col.try(:array)
          [col.type]
        elsif %i(json jsonb).include? col.type
          :object 
        else
          col.type
        end
      end
    end
  end
end
