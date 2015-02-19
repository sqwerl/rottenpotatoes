class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings]
    @find_hash = Hash.new

    session_bool = false
    @order = nil
    if (!@selected_ratings)
      @selected_ratings = Hash.new
    end

    if params.has_key?(:sort)
      @order = session[:sort] = params[:sort]
    elsif (session[:sort])
      session_bool = true
      @order = session[:sort]
    end

    if params.has_key?(:ratings)
      @selected_ratings = session[:selected_ratings] = params[:ratings]
    elsif (session[:selected_ratings_hash])
      session_bool = true
      @selected_ratings = session[:selected_ratings]
    end


    if (session_bool)
      redirect_to movies_path({:sort=>@order,
                               :ratings=>@selected_ratings})
    end

    find = Hash.new
    find[:conditions] = Hash[:rating => @selected_ratings.keys]
    find[:order] = @order

    @movies = Movie.find(:all, find)
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
