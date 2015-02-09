module ActiveCerealizer
  module Adapters
    class ActiveRecord
      def self.fetch(model, association, polymorphic)
        case association.macro
        when :belongs_to
          [model.send(association.foreign_key).to_s,
           polymorphic ? model.send(association.foreign_type) : nil ]
        when :has_one
          model.send(association.name).try(:id).try(:to_s)
        else
          if model.send(association.name).loaded?
            model.send(association.name)
          else
            model.send(association.name).select(:id)
          end.collect do |associated|
            [associated.id.to_s, polymorphic ? associated.class : nil]
          end
        end
      end
    end
  end
end
