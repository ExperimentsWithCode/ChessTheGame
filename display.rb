require_relative 'board.rb'
require_relative 'cursor.rb'
require "colorize"

BG_COLORS = {white: {background: :light_white},
            black: {background: :light_black},
            cursor: {background: :light_yellow},
            selected: {background: :light_green},
            moves: {background: :light_red}}
class Display
  attr_reader :board, :cursor
  attr_accessor :selected_piece

  def initialize(board = nil)
    board ||= Board.new
    @board = board
    @cursor = Cursor.new([0,0], board)
    @selected_piece = nil
  end

  def interactive_display(&prc)
    infinity = true
    while infinity
      system('clear')
      prc.call()
      render
      puts "\n"   #break between boards
      selected_pos = cursor.get_input
      return selected_pos unless selected_pos.nil?
    end
  end

  def set_selected_piece(piece)
    self.selected_piece = piece
  end

  def render
    rendered_board = ""
    board.grid.each_index do |row|
      board.grid[row].each_index do |col|
        rendered_board = render_row(rendered_board, row, col)
      end
      rendered_board << "\n"
    end
    puts rendered_board[0...-1]
  end

  private

  def render_row(rendered_board, row, col)
    piece = board[[row, col]]
    unless piece.class == NullPiece
      rendered_board << piece.to_s.colorize({:color => piece.color}.merge( square_color([row,col]) ) )
    else
      rendered_board << "   ".colorize(square_color([row,col]))
    end
    rendered_board
  end

  def square_color(pos)
    return BG_COLORS[:selected] if board[pos] == selected_piece
    return BG_COLORS[:cursor] if pos == cursor.cursor_pos
    unless selected_piece.nil?
      return BG_COLORS[:moves] if board.valid_moves(selected_piece).include?(pos)
    end
    default_colors(pos)
  end

  def default_colors(pos)
    row, col = pos
    if row % 2 == 0 && col % 2 == 0 ## if row and col are even => white
      return BG_COLORS[:white]
    elsif row % 2 > 0 && col % 2 > 0 ## if row is even, col is odd => white
      return BG_COLORS[:white]
    else ## if row and col are not both even,or row is even, col is even
      return BG_COLORS[:black]
    end
  end
end

if __FILE__ == $0
  d = Display.new
  d.interactive_display
end
