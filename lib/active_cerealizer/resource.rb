module ActiveCerealizer
  class Resource
    attr_accessor :serialized
    attr_reader :model, :context
    
    def initialize(model, ctx={})
      @serialized = {}
      @model, @context = model, ctx
    end
  end
end
