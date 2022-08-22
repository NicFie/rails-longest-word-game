require 'open-uri'
require 'json'

class GamesController < ApplicationController
  ALPHABET = ('A'..'Z').to_a

  def new
    @letters = []
    10.times do
      @letters << ALPHABET.sample
    end
  end

  def score
    @letters = params[:letters].split(' ')
    @word = params[:word]
    @message = "Congratulations! #{@word.upcase} is a valid English word!"
    if !first_check(@word)
      @message = "Sorry, but #{@word.upcase} does not seem to be a valid English word"
    elsif !second_check(@word, @letters)
      @message = "Sorry, but #{@word.upcase} can't be built out of #{params[:letters]}"
    end
  end

  private

  def first_check(attempt)
    attempt.upcase!
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = URI.open(url).read
    JSON.parse(word_serialized)["found"]
  end

  def second_check(attempt, grid)
    check_array = []
    attempt.upcase.chars.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
        check_array.push(letter)
      end
    end
    check_array.length == attempt.length
  end
end
