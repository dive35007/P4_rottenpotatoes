class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
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
    @movie = Movie.new
    if params[:title]
      @movie.title = params[:title]
      @movie.rating = params[:rating]
      @movie.director = params[:director]
      @movie.release_date = params[:release_date]
      @movie.description = params[:description]
    end
  end

  def create
    if params['commit'] != "Cancel"
      @movie = Movie.create!(params[:movie])
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movie_path(@movies.id)
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
      flash[:notice] = "'#{@movie.title}' has no director info. #{@movie.class}"
      redirect_to movies_path
    end
  end
  
  def search_tmdb
    @movies = Movie.find_in_tmdb(params[:search_terms])
    if @movies.class == PatchedOpenStruct
      @movies = [@movies_TMDB]
    end
    @movies_clean = Array.new #@movies_haml is available in template
    @movies.each do |movie|
      director = nil
      if movie.respond_to?(:crew)
        if movie.crew[0].inspect != "nil"
          director = movie.crew[0].name
        end       
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
      flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
      redirect_to movies_path
    end
  end

end


