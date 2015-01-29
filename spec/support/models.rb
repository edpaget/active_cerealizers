ActiveRecord::Base.connection.create_table :meals, force: true do |t|
  t.integer :food_id
  t.string :food_type
  t.integer :beverage_id
end

ActiveRecord::Base.connection.create_table :beverages, force: true do |t|
end

ActiveRecord::Base.connection.create_table :cereals, force: true do |t|
end

ActiveRecord::Base.connection.create_table :sandwiches, force: true do |t|
end

class Meal < ActiveRecord::Base
  belongs_to :beverage
  belongs_to :food, polymorphic: true
end

class Beverage < ActiveRecord::Base
  has_one :meal
end

class Cereal < ActiveRecord::Base
  has_many :meals, as: :food
end

class Sandwich < ActiveRecord::Base
  has_many :meals, as: :food
end
