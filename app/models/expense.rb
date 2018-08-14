class Expense < ApplicationRecord
  validates :amount, presence: true

  belongs_to :property,
    class_name: 'Property',
    foreign_key: :property_id,
    primary_key: :id
end
