class Item < ActiveRecord::Base
  belongs_to :payment, inverse_of: :items
  belongs_to :event, inverse_of: :items
end