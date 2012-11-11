require 'spec_helper'

describe MoviesController do
  describe 'Movie Model' do
    it 'Return list of ratings code' do
      r = Movie.all_ratings
      r.length.should == %w(G PG PG-13 NC-17 R).length
    end
  end
end

