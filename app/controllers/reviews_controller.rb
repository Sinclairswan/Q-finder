class ReviewsController < ApplicationController
    # before_action :authenticate_user!

  # def index
  #   @reviews = Review.all
  # end

  # def show
  #   @review = Review.find(params[:id])
  # end

  def new
    @place = Place.find(params[:place_id])
    @review = Review.new
    if user_signed_in?
      if request.xhr?
        render :new, layout: false
      else
      end
    else
      # status 301
      redirect_to new_user_session_path, status:301
    end
  end

  def create
    @place = Place.find(params[:place_id])
    @review = @place.reviews.new(review_params)
    @review.user_id = current_user.id

    if request.xhr?
     if @review.save
      @place.update_reviews
      render json: @review
     else
        status 422
        "review did not save!"
     end
    else
      if @review.save
        redirect_to place_path(@place)
      else
        render :new, layout: false
      end
    end

  end

  def update
  end

  def delete
  end

  private
  def review_params
    params.require(:review).permit(:rating, :review)
  end
end
