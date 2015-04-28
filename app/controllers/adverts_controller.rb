class AdvertsController < ApplicationController

  before_action :require_user, only: [:create, :new]
  before_action :find_advert, only: [:show, :edit, :update, :destroy]
  before_action :require_author, only: [:update, :destroy]


  def index
    @adverts = Advert.all
  end

  def show
  end

  def new
    @advert = Advert.new
  end

  def create
    advert = current_user.adverts.new(advert_params)
    if advert.save
      redirect_to advert_path(advert), success: "Je advertentie is geplaatst!"
    else
      redirect_to new_advert_path, error: "Je advertentie kon niet worden geplaatst."
    end
  end

  def edit
  end

  def update
    if @advert.update(advert_params)
      redirect_to advert_path(@advert), success: "Je advertentie is bewerkt!"
    else
      redirect_to edit_advert_path(@advert), error: "Je advertentie kon " +
                                                   "niet worden bewerkt."
    end
  end

  def destroy
    @advert.destroy
    redirect_to adverts_path, success: "Je advertentie is verwijderd."
  end

  private
  def advert_params
    params.require(:advert).permit(:title, :description, :price)
  end

  def find_advert
    @advert = Advert.find(params[:id])
  end

  def require_author
    if !current_user || current_user != @advert.user
      redirect_to root_path and return
    end
  end
end
