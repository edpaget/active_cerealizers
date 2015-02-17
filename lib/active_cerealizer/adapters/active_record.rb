module ActiveCerealizer
  module Adapters
    class ActiveRecord
      def self.fetch(model, link) 
        case link.association.macro
        when :belongs_to
          [model.send(association.link.foreign_key).to_s,
           link.polymorphic ? model.send(association.foreign_type) : nil ]
        when :has_one
          model.send(link.association.name).try(:id).try(:to_s)
        else
          if model.send(link.association.name).loaded?
            model.send(link.association.name)
          else
            model.send(link.association.name).select(:id)
          end.collect do |associated|
            [associated.id.to_s, link.polymorphic ? associated.class : nil]
          end
        end
      end
    end
  end
end
