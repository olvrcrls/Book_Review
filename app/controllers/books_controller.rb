class BooksController < ApplicationController
	before_action :find_book, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, only: [:new, :edit, :update, :create]

	def index
		if params[:category].blank?
			@books = Book.all.order('created_at DESC')
		else
			@category_id = Category.find_by(name: params[:category]).id
			@books = Book.where(:category_id => @category_id).order('created_at DESC')
		end
	end #index

	def new
		@book = current_user.books.build
		@categories = category_list
	end #new

	def create
		@book = current_user.books.build(book_params)
		@book.category_id = params[:category_id]

		if @book.save
			redirect_to root_path
		else
			return 'new'
		end
	end #create

	def show
		if @book.reviews.blank?
			@average_review = 0
		else
			@average_review = @book.reviews.average(:rating).round(2)
		end
	end #show

	def edit
		@categories = category_list
	end

	def update
		@book.category_id = params[:category_id]
		if @book.update(book_params)
			redirect_to book_path(@book)
		else
			render 'edit'
		end
	end

	def destroy
		@book.destroy
		redirect_to root_path
	end

	private
		def book_params
			params.require(:book).permit(:title, :author, :description, :category_id, :book_img)
		end
		def find_book
			@book = Book.find(params[:id])
		end
		def category_list
			Category.all.map{ |category| [category.name, category.id] }
		end
end
