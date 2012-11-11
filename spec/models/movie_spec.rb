require 'spec_helper'

describe MoviesController do
  describe 'Movie Model' do
    it 'Return list of ratings code' do
      r = Movie.all_ratings
      r.length.should == %w(G PG PG-13 NC-17 R).length
    end
  end
end

describe Movie do
  describe 'searching Tmdb by keyword' do
    it 'should call Tmdb with title keywords given valid API key' do
      TmdbMovie.should_receive(:find).with(hash_including :title => 'Inception')
      Movie.find_in_tmdb('Inception')
    end
    it 'should raise an InvalidKeyError with no API key' do
      Movie.stub(:api_key).and_return('')
      lambda { Movie.find_in_tmdb('Inception') }.should rescue(ArgumentError)
    end
    it 'should raise an InvalidKeyError with invalid API key' do
      TmdbMovie.stub(:find).and_raise(RuntimeError.new("API returned status code '404'"))
      lambda { Movie.find_in_tmdb('Inception') }.should rescue(RuntimeError)
    end
  end
end