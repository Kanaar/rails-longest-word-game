require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    alphabet = ("A".."Z").to_a
    10.times { @grid << alphabet.sample }
    return @grid
  end

  def score
    @word = params[:word].upcase
    @grid = params[:grid].scan /\w/
    @grid_string = @grid.join(", ")
    url = 'https://wagon-dictionary.herokuapp.com/' + @word
    word_test_response = JSON.parse(open(url).read)

    validity_condition = @word.upcase.split("").all? { |letter| (@grid.count(letter) >= @word.upcase.split("").count(letter)) }

    if ((word_test_response['found']) && validity_condition)
      @message = "Congratulations! #{@word} is a valid English word"
    elsif word_test_response["found"] == false
      @message = "Sorry but #{@word} does not seem to be a valid English word"
    elsif validity_condition == false
      @message = "Sorry but #{@word} can't be build out of #{@grid_string}"
    end
    return @message
  end
end
