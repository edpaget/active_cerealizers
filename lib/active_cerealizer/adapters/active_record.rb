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
    end
  end
end
