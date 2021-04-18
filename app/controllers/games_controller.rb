require 'json'
require 'open-uri'
require 'time'

class GamesController < ApplicationController
  def new
    @start_time = Time.now
    @grid = []
    9.times do
      @grid << ('a'..'z').to_a[rand(26)]
    end
    @grid
  end

  def score
    @word = params[:word]
    @start_time = Time.parse(params[:start_time])
    @grid = params[:grid].split

    @end_time = Time.now
    @score = (@word.length * 5 - (@end_time - @start_time) / 5).round

    message
  end

  private

  def message
    if !possible
      @message = "Sorry, but you can't build \"#{@word}\" from #{@grid[0]}, #{@grid[1]}, #{@grid[2]},
      #{@grid[3]}, #{@grid[4]}, #{@grid[5]}, #{@grid[6]}, #{@grid[7]}, #{@grid[8]}."
    elsif !exists
      @message = "Sorry, but #{@word} doesn't seem to be a valid english word."
    else
      @message = "Congratulations!!! #{@word.capitalize} is valid and you scored #{@score} points."
    end
  end

  def exists
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end

  def possible
    arr_word = @word.downcase.split('')
    @grid.each do |letter|
      if arr_word.include?(letter)
        # deletes this letter from the word array
        arr_word.delete_at(arr_word.index(letter))
      end
    end
    arr_word.empty?
  end
end
