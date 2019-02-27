class CatsController < ApplicationController
  before_action :ensure_logged_in, except: :index
  before_action :ensure_owned_cat, only: [:edit, :update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @requests = CatRentalRequest.where(cat_id: params[:id]).includes(:user)
    render :show
  end

  def new
    if logged_in?
      @cat = Cat.new
      @cat.owner_id = current_user.id
      render :new
    else
      flash[:errors] = ["you must log in to do that!"]
      redirect_to cats_url
    end

  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  
  def ensure_owned_cat
    @cat = Cat.find(params[:id])
    unless @cat.owner_id == current_user.id
      flash.now[:errors] = ["that aint yo cat"]
      redirect_to cat_url(@cat)
    end 
    
  end
  private
  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :owner_id, :sex)
  end
end
