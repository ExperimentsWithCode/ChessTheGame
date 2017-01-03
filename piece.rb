require 'singleton'
require 'colorize'
require_relative "piece_pawn.rb"

class Piece

  attr_accessor :current_pos
  attr_reader :color, :board

  def initialize(color_flag, pos, board)
    @color = color_flag ? :white : :black
    @current_pos = pos
    @board = board
  end

  def to_s
    if self.class == King || self.class == Queen
      self.class.to_s.upcase[0]
    else
      self.class.to_s.downcase[0]
    end
  end

  def update_pos(new_pos)
    self.current_pos = new_pos
  end
end

module Movements
  def slide(deltas)
    possible_positions = []
    deltas.each do |delta|
      out_of_space = false
      possible_positions.concat(slide_valid_moves(self.current_pos, delta))
    end
    possible_positions
  end


  def slide_valid_moves(current_pos, delta)
    pos = [current_pos[0] + delta[0], current_pos[1] + delta[1]]
    if board.in_bounds?(pos)
      unless board[pos].class == NullPiece

        if board[pos].color == self.color
          ## hit own piece
          return []
        else
          ## hit opponent piece
          return [pos]
        end
      else
        ## hit a NullPiece
        return [pos] + slide_valid_moves(pos, delta)
      end
    else
      ## hit out of bounds
      return [] ## hit out of bounds
    end
  end


  def step(deltas)

  end




end
class NullPiece < Piece
  include Singleton
  def initialize
  end
end



class Rook < Piece
  DELTAS = [
    [0, 1],
    [0, -1],
    [1, 0],
    [-1, 0]
  ]
  include Movements
  def move
    slide(DELTAS)
  end

end

class Knight < Piece
  DELTAS = [
  [2, 1],
  [2, -1],
  [1, -2],
  [-1, -2],
  [-2, -1],
  [-2, 1],
  [-1, 2],
  [1, 2]
  ]
end

class Bishop < Piece
  DELTAS = [
    [1, 1],
    [1, -1],
    [-1, -1],
    [-1, 1]
  ]
  include Movements
  def move
    slide(DELTAS)
  end
end

class Queen < Piece
  DELTAS = [
    [0, 1],
    [0, -1],
    [1, 0],
    [-1, 0],
    [1, 1],
    [1, -1],
    [-1, -1],
    [-1, 1]
  ]

  include Movements
  def move
    slide(DELTAS)
  end
end

class King < Piece
end


### List of possible DELTAS
### move is specialize
