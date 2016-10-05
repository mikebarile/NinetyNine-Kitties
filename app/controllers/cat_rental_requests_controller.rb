class CatRentalRequestsController < ApplicationController

  def index
    @cat_rental_requests = CatRentalRequest.all
    render json: @cat_rental_requests
  end

  def new
    @cats = Cat.all
    render :new_request
  end

  def create
    cat_request = CatRentalRequest.new(show_params)
    if cat_request.save
      redirect_to '/cats'
    else
      render json: cat.errors.full_messages
    end
  end

  private

  def show_params
    params.require(:cat_rental_request).permit(:start_date, :end_date, :cat_id)
  end

end
