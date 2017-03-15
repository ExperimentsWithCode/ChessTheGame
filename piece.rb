require 'singleton'
require 'colorize'



class Piece

  attr_accessor :current_pos
  attr_reader :color, :board

  def initialize(color_flag, pos, board)
    @color = color_flag ? :white : :black
    @current_pos = pos
    @board = board
  end


  def to_s
    return "  " if self.is_a? NullPiece
    unicode_rep(self.class,self.color)
  end

  def update_pos(new_pos)
    self.current_pos = new_pos
  end

  private

  def unicode_rep(piece_class, color)
    unicode_hash = { [King, :white] => "\u2654", [Queen, :white] => "\u2655",
                      [Rook, :white] => "\u2656", [Knight, :white] => "\u2658",
                      [Bishop, :white] => "\u2657", [Pawn, :white] => "\u2659",
                      [King, :black] => "\u265A", [Queen, :black] => "\u265B",
                      [Rook, :black] => "\u265C", [Knight, :black] => "\u265E",
                      [Bishop, :black] => "\u265D", [Pawn, :black] => "\u265F"}
    " #{unicode_hash[[piece_class,color]]} "
  end


  def check_moves(deltas)
    possible_positions = []
    deltas.each do |delta|
      out_of_space = false
      possible_positions.concat(check_for_valid_moves(self.current_pos, delta))
    end
    possible_positions
  end


  def check_for_valid_moves(current_pos, delta)
    pos = [current_pos[0] + delta[0], current_pos[1] + delta[1]]
    if board.in_bounds?(pos)
      on_board_valid_moves(pos, delta)
    else ## hit out of bounds
      return []
    end
  end

  def on_board_valid_moves(pos, delta)
    unless board[pos].class == NullPiece
      return board[pos].color == self.color ? [] : [pos]
    else ## hit a NullPiece
      return [pos] if self.is_a?(Knight) || self.is_a?(King)
      return [pos] + check_for_valid_moves(pos, delta) # Moves continuously in this direction
    end
  end
end



class NullPiece < Piece
  include Singleton
  def initialize
  end
end



class Rook < Piece
  # Recursively checks each Delta.
  DELTAS = [
    [0, 1],
    [0, -1],
    [1, 0],
    [-1, 0]
  ]
  def moves
    check_moves(DELTAS)
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
  def moves
    check_moves(DELTAS)
  end
end

class Bishop < Piece
  # Recursively checks each Delta.
  DELTAS = [
    [1, 1],
    [1, -1],
    [-1, -1],
    [-1, 1]
  ]
  def moves
    check_moves(DELTAS)
  end
end

class Queen < Piece
  # Recursively checks each Delta.
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

  def moves
    check_moves(DELTAS)
  end
end

class King < Piece
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
  def moves
    check_moves(DELTAS)
  end
end
