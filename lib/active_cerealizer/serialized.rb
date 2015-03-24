module ActiveCerealizer
  module Serialized
    def permitted?(action)
      test_action(@permitted, action)
    end

    private

    def conditional?(serializer)
      if @if
        eval_conditional(@if, serializer)
      elsif @unless
        !eval_conditional(@unless, serializer)
      else
        true
      end
    end
    
    def required?(action)
      return false if @required.nil?
      test_action(@required, action)
    end

    def test_action(var, action)
      case var
      when TrueClass, FalseClass
        var
      when Symbol
        var == action
      when NilClass
        true
      else
        var.include?(action)
      end
    end
    
    def eval_conditional(conditional, serializer)
      case conditional
      when Proc
        !!conditional.call(serializer.model, serializer.context)
      when Symbol
        !!serializer.send(conditional)
      when NilClass
        true
      else
        raise ArgumentError, "conditional must be Proc or Symbol"
      end
    end
  end
end
