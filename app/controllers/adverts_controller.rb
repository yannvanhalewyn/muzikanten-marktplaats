class AdvertsController < ApplicationController

  before_action :require_user, only: [:create, :new]
  before_action :find_advert, only: [:show, :edit, :update, :destroy]
  before_action :require_author, only: [:edit, :update, :destroy]


  def index
    @adverts = Advert.paginate(page: params[:page], per_page: 10).order("created_at DESC")

    respond_to do |wants|
      wants.html  # render adverts/index.html.erb
      wants.js    # render adverts/index.js.erb
    end
  end

  def show
  end

  def new
    @advert = Advert.new
  end

  def create
    @advert = current_user.adverts.new(advert_params)
    if params[:img_ids]
      @advert.images << Image.find(params[:img_ids].split(","))
    end
    if @advert.save
      redirect_to advert_path(@advert), success: t("flash.add-advert-success")
    else
      flash[:error] = t("flash.add-advert-fail")
      render action: :new
    end
  end

  def edit
  end

  def update
    if params[:img_ids]
      @advert.images << Image.find(params[:img_ids].split(","))
    end
    if @advert.update(advert_params)
      redirect_to advert_path(@advert), success: t("flash.edit-advert-success")
    else
      redirect_to edit_advert_path(@advert), error: t("flash.edit-advert-fail")
    end
  end

  def destroy
    @advert.destroy
    redirect_to adverts_path, success: t("flash.delete-advert-success")
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
