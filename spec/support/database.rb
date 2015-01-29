require 'active_record'

module Database
  def self.connect
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: ":memory:"
    )
    load("support/models.rb")
  end
end
