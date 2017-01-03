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
      possible_positions.concat(valid_moves(self.current_pos, delta))
    end
    possible_positions
  end


  def valid_moves(current_pos, delta)
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
        return [pos] if self.is_a?(Knight) || self.is_a?(King)
        return [pos] + valid_moves(pos, delta)
      end
    else
      ## hit out of bounds
      return [] ## hit out of bounds
    end
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


### List of possible DELTAS
### move is specialize
