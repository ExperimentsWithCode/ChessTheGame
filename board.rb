require_relative "piece.rb"


class CantMoveWhatsNotThere < StandardError
end
class NotYourPiece < StandardError
end
class OffTheBoard < StandardError
end

class Board
  attr_reader :grid

  def initialize
    @grid = []
    set
  end


  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def in_bounds?(pos)
    return false if pos[0] < 0 || pos[1] < 0
    return true if self[pos]
    false
  end

  def move_piece(start_pos, end_pos)
    piece = [start_pos]
    raise NotYourPiece.new("There is no piece at that position") if piece.is_a? NullPiece || piece.nil?
    raise OffTheBoard.new("Your destination is not on the board") if [end_pos].nil?
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece
  end
# begin
# rescue NotYourPiece => e
#   puts "Error: #{e.message}"
# rescue OffTheBoard =>
#   puts "Error: #{e.message}"
# end
  private

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def set
    color_flag_options = [true, false]
    color_flag_options.each do |color_flag|
      half_board = []
      if color_flag
        half_board << generate_outer_row(color_flag)
        half_board << generate_pawn_row(color_flag)
        half_board << generate_nul_row
        half_board << generate_nul_row
      else
        half_board << generate_nul_row
        half_board << generate_nul_row
        half_board << generate_pawn_row(color_flag)
        half_board << generate_outer_row(color_flag)
      end
      grid.concat(half_board)
    end
  end

  def generate_pawn_row(color_flag)
    pawn_row = []
    8.times { pawn_row << Pawn.new(color_flag)}
    pawn_row
  end

  def generate_outer_row(color_flag)
    ### color_flag == true is white
    ### color_flag == false is black
    outer_row = [
      Rook.new(color_flag),
      Knight.new(color_flag),
      Bishop.new(color_flag),
      Queen.new(color_flag),
      King.new(color_flag),
      Bishop.new(color_flag),
      Knight.new(color_flag),
      Rook.new(color_flag),
    ]
    outer_row
  end

  def generate_nul_row()
    null_row = []
    8.times { null_row << NullPiece.instance }
    null_row
  end
end
