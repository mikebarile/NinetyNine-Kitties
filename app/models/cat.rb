require 'date'

class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: { in: %w(black white orange blue cappucino)}
  validates :sex, inclusion: { in: %w(M F)}

  def age
    (DateTime.now.mjd - birth_date.mjd) / 365
  end

  def persisted?
    !id.nil?
  end

  has_many :cat_rental_requests,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: :CatRentalRequest,
  dependent: :destroy
end
