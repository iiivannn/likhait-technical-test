class Expense < ApplicationRecord
  belongs_to :category

  attr_accessor :client_date

  validates :date, presence: true
  validate :date_cannot_be_in_the_future

  private

  def date_cannot_be_in_the_future
    return unless date.present?

    current_date = if client_date.present?
      parse_client_date
    else
      Date.current
    end

    if date > current_date
      errors.add(:date, "cannot be in the future")
    end
  end

  def parse_client_date
    Date.parse(client_date)
  rescue ArgumentError
    Date.current
  end
end
