require_relative 'board.rb'
require_relative 'cursor.rb'
require "colorize"


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
      #break between boards
      puts "\n"
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
        piece = board[[row, col]]
        unless piece.class == NullPiece
          rendered_board << piece.to_s.colorize({:color => piece.color}.merge( square_color([row,col]) ) )
        else
          rendered_board << "   ".colorize(square_color([row,col]))
        end
        #rendered_board << "|"
      end
      rendered_board << "\n"
    end
    puts rendered_board[0...-1]
  end

  private

  def square_color(pos)
    colors = [{:background => :light_white}, {:background => :light_black}, {:background => :light_yellow}, {:background => :light_green},{:background => :light_red}]
    return colors[3] if board[pos] == selected_piece
    return colors[2] if pos == cursor.cursor_pos
    unless selected_piece.nil?
      return colors[4] if board.valid_moves(selected_piece).include?(pos)
    end
    row, col = pos
    ## if row and col are even => white
    if row % 2 == 0 && col % 2 == 0
      colors[0]
    ## if row is even, col is odd => white
    elsif row % 2 > 0 && col % 2 > 0
      colors[0]
    ### if row and col are not both even,or row is even, col is even
    else
      colors[1]
    end
  end

end

if __FILE__ == $0
  d = Display.new
  d.interactive_display
end
