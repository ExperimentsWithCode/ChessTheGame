require_relative "piece.rb"
require_relative "piece_pawn.rb"
require 'byebug'


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
    puts "callate papi, it's a board and that should be good enough for you"
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



  def valid_moves(piece)
    valid_moves = []
    original_pos = piece.current_pos
    piece.moves.each do |move|
      place_holder = move_piece_and_save(original_pos, move)
      valid_moves << move unless in_check?(piece.color)
      self[original_pos] = piece
      self[move] = place_holder
      piece.update_pos(original_pos)
    end
    valid_moves
  end

  def in_check?(color, king_pos = nil)
    opposite_color = color == :white ? :black : :white
    king_pos ||= get_king_pos(color)
    grid.each do |row|
      row.each do |piece|
        unless piece.is_a?(NullPiece)
          return true if piece.color == opposite_color && piece.moves.include?(king_pos)
        end
      end
    end
    false
  end



  def in_checkmate?(color)
    king_pos = get_king_pos(color)
    return false unless in_check?(color, king_pos)
    #self[king_pos].moves.each { |king_escape| return false unless in_check?(color, king_escape) }
    grid.each do |row|
      row.each do |piece|
        unless piece.is_a?(NullPiece)
          if piece.color == color
            unless valid_moves(piece).empty?
              return false
            end
          end
        end
      end
    end
    puts "Oh so you think you're special, fine you win"
    true
  end

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

  def get_king_pos(color)
    grid.each do |row|
      row.each do |piece|
        return piece.current_pos if piece.is_a?(King) && piece.color == color
        #debugger if piece.is_a?(King) && piece.color == color
      end
    end
  end

  def move_piece_and_save(start_pos, end_pos)
    place_holder = self[end_pos]
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
    self[end_pos].update_pos(end_pos)
    place_holder
  end



end
