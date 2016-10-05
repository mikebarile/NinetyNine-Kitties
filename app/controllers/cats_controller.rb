class CatsController < ApplicationController

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @kitty_requests = CatRentalRequest.where("cat_id = #{@cat.id}").order(:start_date)
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    cat = Cat.new(show_params)
    if (cat.save)
      redirect_to "/cats"
    else
      render json: cat.errors.full_messages
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    cat = Cat.find(params[:id])
    if cat.update(show_params)
      redirect_to "/cats/#{cat.id}"
    else
      render json: cat.errors.full_messages
    end
  end

  private

  def show_params
    params.require(:cat).permit(:name, :sex, :color, :birth_date, :description)
  end
end
