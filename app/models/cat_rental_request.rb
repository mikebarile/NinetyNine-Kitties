class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: {in: %w(PENDING APPROVED DENIED)}
  validate :overlapping_approved_requests

  def overlapping_requests
    CatRentalRequest.where("(start_date < '#{start_date}'::DATE AND end_date > '#{start_date}'::DATE)
      OR (start_date < '#{end_date}'::DATE AND end_date > '#{end_date}'::DATE)
      OR (start_date between '#{start_date}'::DATE AND '#{end_date}'::DATE)
      OR (end_date between '#{start_date}'::DATE AND '#{end_date}'::DATE)
      AND cat_id = #{cat_id}")
  end

  def overlapping_approved_requests
    if !overlapping_requests.where("status = 'APPROVED'").empty?
      errors[:base] << "Can't have overlapping approved requests!"
    end
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end

  def approve!
    if status == "PENDING"
      transaction do
        update(status: "APPROVED")
        overlapping_pending_requests.each do |bad_request|
          bad_request.deny!
        end
      end
    end
  end

  def deny!
    update(status: "DENIED")
  end

  belongs_to :cat,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: :Cat
end
