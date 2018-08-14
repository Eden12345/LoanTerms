class Unit < ApplicationRecord
  validates :monthly_rent, :annual_rent, presence: true

  belongs_to :property,
    class_name: 'Property',
    foreign_key: :property_id,
    primary_key: :id
end
