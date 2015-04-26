class CommentsController < ApplicationController
  def default_url_options
    { user_id: 1 }
  end

  def create
    @advert = Advert.find(params[:advert_id])
    # TODO: Update 'merge user_id' when user authentication is ready
    comment = @advert.comments.new(comment_params.merge({user_id: 1}))
    if comment.save
      redirect_to advert_path(@advert), success: "Je comment was geplaatst."
    else
      redirect_to advert_path(@advert), error: "Je comment werd niet geplaatst."
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :user_id)
  end
end
