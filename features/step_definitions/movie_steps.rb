# Add a declarative step here for populating the DB with movies.
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  first_position = page.body.index(e1)
  second_position = page.body.index(e2)
  first_position.should < second_position
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list = rating_list.gsub("'", "").gsub("\"", "")
  ratings = rating_list.split(/[\s,]+/)
  
  case uncheck
  when nil
    ratings.each do |rating|
      steps %Q{
        When I check "ratings_#{rating}"
      }
    end

  when 'un'
    ratings.each do |rating|
      steps %Q{
        When I uncheck "ratings_#{rating}"
      }
    end
  end
  
end

Then /the director of "(.+)" should be "(.+)"$/ do |movie, director|
  obj = Movie.find_by_title(movie)
  director.should == obj.director
end

