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

  def inspect
    puts "it's a board and that should be good enough for you"
  end


  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def in_bounds?(pos)
    return false if pos[0] < 0 || pos[1] < 0
    return false if pos[0] > 7 || pos[1] > 7
    true
  end

  def move_piece(start_pos, end_pos)
    piece = [start_pos]
    raise NotYourPiece.new("There is no piece at that position") if piece.is_a? NullPiece || piece.nil?
    raise OffTheBoard.new("Your destination is not on the board") if [end_pos].nil?
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
    self[end_pos].update_pos(end_pos)
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
    row = color_flag ? 1 : 6
    8.times { |col| pawn_row << Pawn.new(color_flag, [row, col], self)}
    pawn_row
  end

  def generate_outer_row(color_flag)
    ### color_flag == true is white
    ### color_flag == false is black
    row = color_flag ? 0 : 7
    outer_row = [
      Rook.new(color_flag, [row,0], self),
      Knight.new(color_flag, [row, 1], self),
      Bishop.new(color_flag, [row, 2], self),
      King.new(color_flag, [row, 3], self),
      Queen.new(color_flag, [row, 4], self),
      Bishop.new(color_flag, [row, 5], self),
      Knight.new(color_flag, [row, 6], self),
      Rook.new(color_flag, [row, 7], self),
    ]
    outer_row
  end

  def generate_nul_row()
    null_row = []
    8.times { null_row << NullPiece.instance }
    null_row
  end
end
