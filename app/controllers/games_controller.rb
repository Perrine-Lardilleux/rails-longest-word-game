require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    if included? && englishword?
      @score = "Congratulation! #{params[:word_proposal]} is a valid English word!"
    elsif included? == false
      @score = "Sorry but #{params[:word_proposal]} cant be build out of  #{params[:letters]}"
    elsif englishword? == false
      @score = "Sorry but #{params[:word_proposal]} does not seem to be a valid English word.."
    end
  end

  def included?
    @answer = params[:word_proposal]
    @letters_answer = @answer.split('')
    @letters_answer.each do |letter|
      unless params[:letters].include? letter.upcase
        return false
      end
    end
    true
  end

  def englishword?
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{params[:word_proposal]}")
    dictionary = JSON.parse(response.read)
    dictionary["found"] == true
  end
end
