class MoviesController < ApplicationController
  before_filter :set_current_user, :except => [ :index, :show ]

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:order => :release_date}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort] != session[:sort]
      session[:sort] = sort
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
  end

  def new
    @movie = Movie.new(params[:movie])
  end

  def create
    if params['commit'] != "Cancel"
      @movie = Movie.create!(params[:movie])
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movie_path(@movie.id)
    else
      redirect_to movies_path
    end
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    if params['commit'] != "Cancel"
      @movie = Movie.find params[:id]
      @movie.update_attributes!(params[:movie])
      flash[:notice] = "#{@movie.title} was successfully updated."
    end
    redirect_to movie_path(params[:id])
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def similar
    @movie = Movie.find(params[:id])
    if @movie
      if @movie.director != nil
        if @movie.director.length > 0
          @similarsDirector = Movie.find_all_by_director(@movie.director)
          return
        end
      end
      flash[:notice] = "'#{@movie.title}' has no director info."
      redirect_to movies_path
    end
  end
  
  def search_tmdb
    @movies = Movie.find_in_tmdb(params[:search_terms])
    
    # Exceptions
    if @movies.class == String
      if @movies =~ /status code '404'/
        flash[:warning] = "Search not available."
        redirect_to movies_path; return
      elsif @movies =~ /must be set before using the API/
        flash[:warning] = "Search not available."
        redirect_to movies_path; return
      end
      flash[:warning] = "An unknown error has occurred."
      redirect_to movies_path; return
    end
    
    if @movies.class == PatchedOpenStruct # When TMDB return 1 movie
      @movies = [@movies]
    end
    @movies_clean = Array.new #@movies_haml is available in template
    @movies.each do |movie|
      begin # This trick is for validate "director"
        director = movie.crew[0].name
      rescue
        director = nil
      end
      m = Movie.new
      m.title  = movie.title  if movie.respond_to?(:title)
      m.rating = movie.rating if movie.respond_to?(:rating)
      m.release_date = movie.release_date if movie.respond_to?(:release_date)
      m.description = movie.overview if movie.respond_to?(:overview)
      m.director = director
      @movies_clean << m
    end
    if @movies_clean.length > 0
      flash[:notice] = "About #{@movies_clean.length} results"
    else
      flash[:notice] = "'#{params[:search_terms]}' was not found in TMDb."
      redirect_to movies_path
    end
  end

end


