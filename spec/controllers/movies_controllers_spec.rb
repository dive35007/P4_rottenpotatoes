require 'spec_helper'

describe MoviesController do
    
  fixtures :movies
  before :each do
    @fake_alien = movies(:alien)
    @fake_star_wars = movies(:star_wars)
  end
  
    
#   describe "GET index" do
#     it "call model method find_all_by_rating, assigns all movies as @movies" do
#       Movie.should_receive(:find_all_by_rating).and_return(@fake_star_wars)
#       get :index
#       assigns[:movies].should == @fake_star_wars
#     end
#     it "should sort movies depending params :sort by 'title'" do
#       get :index, :sort => 'title'
#       assigns[:title_header].should == 'hilite'
#     end
#     it "should sort movies depending params :sort by 'release_date'" do
#       get :index, :sort => 'release_date'
#       assigns[:date_header].should == 'hilite'
#     end
#     it "should filter movies depending params :ratings" do
#       get :index, :ratings => 'G'
#       assigns[:selected_ratings].should == 'G'
#     end
#   end
    
#   describe "GET show" do
#     it "assigns the requested movie as @movie" do
#       Movie.stub!(:find).with("10").and_return(@fake_star_wars)
#       get :show, :id => "10"
#       assigns[:movie].should == @fake_star_wars
#     end
#   end
#   
#   describe "GET new" do
#     it "call model method new, assigns params[:movie] as @movie" do
#       Movie.should_receive(:new)
#       get :new
#       assigns[:movie].class == Movie.class
#     end
#   end
#   
  describe "GET edit" do
    it "call model method find, assigns params[:movie] as @movie" do
      assigns[:current_user].inspect == "d"
      Movie.should_receive(:find).with("1").and_return(@fake_alien)
      get :edit, :id => "1"
      assigns[:movie].should == @fake_alien
    end
  end
#   
#   describe "DELETE destroy" do
#     it "call model method find, destroy a movie, redirect_to movies_path" do
#       Movie.should_receive(:find).with("2").and_return(@fake_alien)
#       @fake_alien.should_receive(:destroy)
#       delete :destroy, :id => "2"
#       response.should redirect_to(movies_path)
#     end
#   end
#   
#   describe "PUT update" do
#     it "call model method find, receives a correct movie to update" do
#       Movie.should_receive(:find).with("3").and_return(@fake_alien)
#       @fake_alien.should_receive(:update_attributes!)
#       put :update, :id => "3", :movie => @fake_alien.attributes
#       assigns(:movie).should == @fake_alien
#       response.should redirect_to movie_path(:id => @fake_alien.id)
#     end
#   end
#   
#   describe "POST create" do
#     it "Update: when click update redirect_to the movie_path" do
#       Movie.should_receive(:create!).with({'title' => "Alien"}).and_return(@fake_alien)
#       post :create, :movie => {:title => "Alien"}
#       assigns(:movie).should == @fake_alien
#       response.should redirect_to movie_path(:id => @fake_alien.id)
#     end
#     it "Cancel: when click Cancel redirect_to movies_path" do
#       Movie.should_not_receive(:create!)
#       post :create, :movie => {:title => "Alien"}, :commit => 'Cancel'
#       assigns(:movie).should == nil
#       response.should redirect_to movies_path
#     end
#   end
#   
#   describe "GET similar" do
#     it "assigns a similars movies as @similarsDirector" do
#       Movie.should_receive(:find_all_by_director).with(@fake_star_wars.director).
#         and_return(@fake_star_wars)
#       post :similar, :id => "1"
#       assigns[:similarsDirector].should == @fake_star_wars
#     end
#     it "get similars movies when there is no director" do
#       Movie.should_receive(:find).with("1").and_return(@fake_alien)
#       post :similar, :id => "1"
#       flash[:notice].should == "'#{@fake_alien.title}' has no director info."
#     end
#   end
# 
# 
#   describe 'searching TMDb' do
#     before :each do
#       @fake_results = [Movie.new]
#     end
#     it 'should call the model method that performs TMDb search' do
#       Movie.should_receive(:find_in_tmdb).with('hardware').and_return(@fake_results)
#       post :search_tmdb, {:search_terms => 'hardware'}
#     end
#     
#     it 'when TMDb search return one movie' do
#       Movie.should_receive(:find_in_tmdb).with('hardware').and_return(PatchedOpenStruct.new)
#       post :search_tmdb, {:search_terms => 'hardware'}
#       assigns[:movies].class == Array
#     end
#     
#     describe 'after valid search' do
#       before :each do
#         Movie.stub(:find_in_tmdb).and_return(@fake_results)
#         post :search_tmdb, {:search_terms => 'hardware'}
#       end
#       it 'should select the Search Results template for rendering' do
#         response.should render_template('search_tmdb')
#       end
#       it 'should make the TMDb search results available to that template' do
#         assigns(:movies).should == @fake_results
#       end
#     end
#     
#     describe 'after a invalid search' do
#       before :each do
#         Movie.stub(:find_in_tmdb).and_return([])
#         post :search_tmdb, {:search_terms => 'hardware'}
#       end
#       it 'should redirect to index' do
#         response.should redirect_to movies_path
#       end
#       it 'should see a message for search results' do
#         flash[:notice].should == "'hardware' was not found in TMDb."
#       end
#     end
#     
#     describe 'when there is no api_key' do
#       before :each do
#         Movie.stub(:api_key).and_return('')
#         post :search_tmdb, {:search_terms => 'hardware'}
#       end
#       it 'should raise an InvalidKeyError with no API key' do
#         response.should redirect_to movies_path
#       end
#       it 'should see a message for search results' do
#         flash[:warning].should == "Search not available."
#       end
#     end
#     
#     describe 'when api_key is invalid' do
#       before :each do
#         TmdbMovie.stub(:find).and_raise(RuntimeError.new("API returned status code '404'"))
#         post :search_tmdb, {:search_terms => 'hardware'}
#       end
#       it 'should raise an InvalidKeyError with no API key' do
#         response.should redirect_to movies_path
#       end
#       it 'should see a message for search results' do
#         flash[:warning].should == "Search not available."
#       end
#     end
#     
#     describe 'when something strange happens' do
#       before :each do
#         TmdbMovie.stub(:find).and_raise(RuntimeError.new("something strange"))
#         post :search_tmdb, {:search_terms => 'hardware'}
#       end
#       it 'should rescue an InvalidKeyError with no API key' do
#         response.should redirect_to movies_path
#       end
#       it 'should see a message for search results' do
#         flash[:warning].should == "An unknown error has occurred."
#       end
#     end
#     
#   end

    
end
