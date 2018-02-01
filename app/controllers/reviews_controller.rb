class ReviewsController < ApplicationController
	before_action :find_book 
	before_action :find_review, only: [:edit, :update, :destroy]
	before_action :authenticate_user!, only: [:create, :edit, :update, :new]
	def new
		@review = Review.new
	end #new

	def create
		@review = Review.new(review_params)
		@review.book_id = @book.id
		@review.user_id = current_user.id
		if @review.save
			redirect_to book_path(@book)
		else
			render 'new'
		end
	end #create


	def edit
	end #edit

	def update
		if @review.update(review_params)
			redirect_to book_path(@book)
		else
			render 'edit'
		end
	end #update

	def destroy
		@review.destroy
		redirect_to book_path(@book)
	end #destroy

	private
		def review_params
			params.require(:review).permit(:rating, :comment)
		end
		def find_review
			@review = Review.find(params[:id])
		end
		def find_book
			@book = Book.find(params[:book_id])
		end
end
