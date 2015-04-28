class AdvertsController < ApplicationController

  def index
    @adverts = Advert.all
  end

  def show
    @advert = Advert.find(params[:id])
  end

  def new
    @advert = Advert.new
  end

  def create
    @user = current_user
    if !@user
      redirect_to root_path, error: "Je moet ingelogd zijn om een advertentie te plaatsen"
      return
    end

    advert = @user.adverts.new(advert_params)
    if advert.save
      redirect_to advert_path(advert), success: "Je advertentie is geplaatst!"
    else
      redirect_to new_advert_path, error: "Je advertentie kon niet worden geplaatst."
    end
  end

  def edit
    @advert = Advert.find(params[:id])
  end

  def update
    advert = Advert.find(params[:id])
    if advert.update(advert_params)
      redirect_to advert_path(advert), success: "Je advertentie is bewerkt!"
    else
      redirect_to edit_advert_path(advert), error: "Je advertentie kon " +
                                                   "niet worden bewerkt."
    end
  end

  def destroy # TODO: Destory nested resources (comments)
    advert = Advert.find(params[:id])
    advert.destroy
    redirect_to adverts_path, success: "Je advertentie is verwijderd."
  end

  private
  def advert_params
    params.require(:advert).permit(:title, :description, :price)
  end
end
