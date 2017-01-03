###the game
require_relative "player.rb"
require_relative "display.rb"
require_relative "board.rb"
require 'byebug'


class Game
  attr_reader :player_1, :player_2, :board, :display

  def initialize(player_1, player_2)
    @display = Display.new
    @board = @display.board
    @player_1 = Player.new(player_1, :white)
    @player_2 = Player.new(player_2, :black)

  end

  def play
    current_player = player_1
    until board.in_checkmate?(current_player.color)
      current_player.play_turn
      selected_pos = display.interactive_display
      switch = handle_selected_pos(current_player, selected_pos)
      current_player = switch_current_player(current_player) if switch
    end
  end

  private


  def switch_current_player(current_player = nil)
    display.set_selected_piece(nil)
    return player_2 if current_player == player_1
    player_1
  end

  def handle_selected_pos(current_player, selected_pos)
    piece = board[selected_pos]
    if display.selected_piece.nil? # there is no currently selected_piece
      if check_selection?(selected_pos, current_player.color)
        display.set_selected_piece(piece)
      else
        puts "That was not a valid selection"
        current_player.play_turn
      end
      return false
    else # there is currently selected_piece
      piece = display.selected_piece
      if unavailable_move?(piece, selected_pos)
        display.set_selected_piece(nil)
        puts "Invalid move"
        sleep(1)
      elsif invalid_move?(piece, selected_pos)
        display.set_selected_piece(nil)
        puts "You cant put your King in danger!"
        sleep(1)
      else
        board.move_piece(piece.current_pos, selected_pos)
        return true
      end
    end
  end

  def check_selection?(pos, player_color)
    return false if board[pos].is_a?(NullPiece)
    board[pos].color == player_color
  end

  def unavailable_move?(piece, move_pos)
    piece.moves.include?(move_pos) ? false : true
  end

  def invalid_move?(piece, move_pos)
    board.valid_moves(piece).include?(move_pos) ? false : true
  end

end

if __FILE__ == $0
  g = Game.new("Kyle","Meir")
  g.play
end
