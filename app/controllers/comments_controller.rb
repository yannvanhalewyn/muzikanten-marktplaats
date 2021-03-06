class CommentsController < ApplicationController
  before_filter :require_user, only: [:create]

  def create
    @advert = Advert.find(params[:advert_id])
    comment = @advert.comments.new(comment_params)
    comment.user_id = current_user.to_param
    if comment.save
      redirect_to advert_path(@advert), success: t("flash.add-comment-success")
    else
      redirect_to advert_path(@advert), error: t("flash.add-comment-fail")
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
