class AdvertsController < ApplicationController

  before_action :require_user, only: [:create, :new]
  before_action :find_advert, only: [:show, :edit, :update,
                                      :set_for_sale, :reserve, :sell,
                                      :destroy]
  before_action :require_author, only: [:edit, :update, :set_for_sale,
                                        :reserve, :sell, :destroy]


  def index
    @search = Advert.search do
      fulltext params[:search]
    end
    @adverts = @search.results
    # @adverts = Advert.paginate(page: params[:page], per_page: 10).order("created_at DESC")

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

  def set_for_sale
    @advert.for_sale!
    redirect_to advert_path(@advert), success: t("flash.update-advert-for-sale")
  end

  def reserve
    @advert.reserved!
    redirect_to advert_path(@advert), success: t("flash.update-advert-reserved")
  end

  def sell
    @advert.sold!
    redirect_to advert_path(@advert), success: t("flash.update-advert-sold")
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
