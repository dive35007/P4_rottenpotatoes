class Movie < ActiveRecord::Base
  class Movie::InvalidKeyError < StandardError ; end

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.api_key
    "04a09640f9e82eff1f91e3a5cf111969"
  end

  def self.find_in_tmdb(string)
    Tmdb.api_key = self.api_key
    begin
      TmdbMovie.find(:title => string)
    rescue ArgumentError, RuntimeError => tmdb_error
        return tmdb_error.message
    end
  end

end

