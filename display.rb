require_relative 'board.rb'
require_relative 'cursor.rb'
require "colorize"


class Display
  attr_reader :board, :cursor

  def initialize(board = nil)
    board ||= Board.new
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def interactive_display
    infinity = true
    while infinity
      system('clear')
      render
      puts "\n"  #break between boards
      cursor.get_input
    end
  end


  def render
    rendered_board = "|"
    board.grid.each_index do |row|
      board.grid[row].each_index do |col|
        piece = board[[row, col]]
        unless piece.class == NullPiece
          rendered_board << piece.to_s.colorize({:color => piece.color}.merge( square_color([row,col]) ) )
        else
          rendered_board << " ".colorize(square_color([row,col]))
        end
        rendered_board << "|"
      end
      rendered_board << "\n|"
    end
    puts rendered_board[0...-1]
  end

  def square_color(pos)
    colors = [{:background => :light_white}, {:background => :light_black}, {:background => :light_blue}]
    return colors[2] if pos == cursor.cursor_pos
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
