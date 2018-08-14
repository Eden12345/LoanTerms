class Property < ApplicationRecord
  validates :address, :cap_rate, presence: true

  belongs_to :user,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id

  has_many :units,
    class_name: 'Unit',
    foreign_key: :property_id,
    primary_key: :id

  has_many :units,
    class_name: 'Unit',
    foreign_key: :property_id,
    primary_key: :id
end
