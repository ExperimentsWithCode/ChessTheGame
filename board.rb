require_relative "piece.rb"
require_relative "piece_pawn.rb"
require 'byebug'

# color_flag == true is white
# color_flag == false is black

class NotYourPiece < StandardError
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
    return false if pos[0] < 0 || pos[1] < 0 || pos[0] > 7 || pos[1] > 7
    true
  end

  def move_piece(start_pos, end_pos)
    piece = [start_pos]
    if piece.is_a? NullPiece || piece.nil?
      raise NotYourPiece.new("There is no piece at that position")
    end
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
    self[end_pos].update_pos(end_pos)
  end

  # Of moves piece can make, find which dont result in self check.
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

  # Checks if the king is currently in check by any piece
  def in_check?(color, king_pos = nil)
    opposite_color = color == :white ? :black : :white
    king_pos ||= get_king_pos(color)
    grid.each do |row|
      row.each do |piece|
        return true if check_if_check?(piece, king_pos, opposite_color)
      end
    end
    false
  end

  # Checks if in check.
  # Checks if any moves available
  #   which would result in no check for any piece
  def in_checkmate?(color)
    king_pos = get_king_pos(color)
    return false unless in_check?(color, king_pos)
    grid.each do |row|
      row.each do |piece|
        return false unless check_if_avoid_checkmate?(piece, color)
      end
    end
    puts "You win"
    true
  end

  private

  # Checks if the king is currently in check by specific piece
  def check_if_check?(piece, king_pos, opposite_color)
    unless piece.is_a?(NullPiece)
      if piece.color == opposite_color && piece.moves.include?(king_pos)
        return true
      end
    end
    false
  end

  # Checks if any moves available
  #   which would result in no check for specific piece
  def check_if_avoid_checkmate?(piece, color)
    unless piece.is_a?(NullPiece)
      if piece.color == color
        return false unless valid_moves(piece).empty?
      end
    end
    true
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def set
    color_flag_options = [true, false]
    color_flag_options.each do |color_flag|
      half_board = []
      half_board << generate_outer_row(color_flag)
      half_board << generate_pawn_row(color_flag)
      2.times { half_board << generate_nul_row }
      color_flag ? grid.concat(half_board) : grid.concat(half_board.reverse)
    end
  end

  def generate_pawn_row(color_flag)
    pawn_row = []
    row = color_flag ? 1 : 6
    8.times { |col| pawn_row << Pawn.new(color_flag, [row, col], self)}
    pawn_row
  end

  def generate_outer_row(color_flag)
    outer_row_pieces = [Rook, Knight, Bishop, Queen,
                        King, Bishop, Knight, Rook ]
    row = color_flag ? 0 : 7
    outer_row = []
    outer_row_pieces.each_with_index do |piece, index|
      outer_row << piece.new(color_flag, [row, index], self)
    end
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
      end
    end
  end

  # Move piece and save current location for future
  def move_piece_and_save(start_pos, end_pos)
    place_holder = self[end_pos]
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
    self[end_pos].update_pos(end_pos)
    place_holder
  end
end

def move_piece(start_pos, end_pos)
  piece = [start_pos]
  if piece.is_a? NullPiece || piece.nil?
    raise NotYourPiece.new("There is no piece at that position")
  end
  self[end_pos] = self[start_pos]
  self[start_pos] = NullPiece.instance
  self[end_pos].update_pos(end_pos)
end
