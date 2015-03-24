module ActiveCerealizer
  class Location
    def initialize(url)
      @url = url[-1]
    end

    def format(id)
      location = "/#{@url.to_s}"
      location += "/#{id}" if id
      location
    end
  end
end
