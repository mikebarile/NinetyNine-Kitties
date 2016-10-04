require 'date'

class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: { in: %w(black white orange blue cappucino)}
  validates :sex, inclusion: { in: %w(M F)}

  def age
    (DateTime.now.mjd - birth_date.mjd) / 365
  end
end
