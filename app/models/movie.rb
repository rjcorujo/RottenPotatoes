class Movie < ActiveRecord::Base

  def self.list_ratings
    movie_ratings = Movie.select(:rating)
    raw_ratings = movie_ratings.map { |x| x.rating }
    return raw_ratings.uniq
  end  
end
