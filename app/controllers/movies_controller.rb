class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    ratings = params[:ratings]
    order = params[:order]
    
    if (not params[:ratings] and not params[:order])
      ratings = session[:ratings]
      order = session[:order]
      redirect_to movies_path(:order => order,:ratings => ratings)
    end
    
    session[:ratings] = ratings
    session[:order] = order
    
    
    @all_ratings = Movie.list_ratings
    @rating_values = {}
    filters = {}
    if ratings
      ratings.keys.each { |x|
        @rating_values[x] = "1"
      }
      filters[:rating] = ratings.keys
    end 
    
    ordered_fields = []
    
    if (order == 'title' or order == 'release_date') 
      ordered_fields = [order]
      if order == 'title'
        @title_order = true
      else
        @release_date_order = true
      end
    end
    
    @movies = Movie.find(:all,:order => ordered_fields, :conditions => filters)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
