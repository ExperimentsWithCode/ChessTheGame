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
    game_loop(current_player, true)
    system('clear')
    display.render
    print "WINNER!"
  end

  private

  def switch_current_player(current_player = nil)
    display.set_selected_piece(nil)
    return player_2 if current_player == player_1
    player_1
  end

  def game_loop(current_player, switch)
    print_proc = Proc.new { if board.in_check?(current_player.color)
                  puts "#{current_player.name} you are in check! Make your move"
                else
                  puts "#{current_player.name} make your move"
                end
                }
    until board.in_checkmate?(current_player.color)
      selected_pos = display.interactive_display(&print_proc)
      switch = handle_selected_pos(current_player, selected_pos)
      current_player = switch_current_player(current_player) if switch
    end
  end

  def handle_selected_pos(current_player, selected_pos)
    if display.selected_piece.nil? # there is no currently selected_piece
      piece = board[selected_pos]
      check_selection?(selected_pos, current_player.color, piece)
    else # there is currently selected_piece
      piece = display.selected_piece
      return check_attempted_move(piece, selected_pos)
    end
    false
  end

  private

  def check_selection?(pos, player_color, piece)
    if board[pos].is_a?(NullPiece)  || board[pos].color != player_color
      puts "That was not a valid selection"
      sleep(1)
    else
      display.set_selected_piece(piece)
      board[pos].color == player_color
    end
  end

  def check_attempted_move(piece, selected_pos)
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
    false
  end

  def unavailable_move?(piece, move_pos)
    piece.moves.include?(move_pos) ? false : true
  end

  def invalid_move?(piece, move_pos)
    board.valid_moves(piece).include?(move_pos) ? false : true
  end
end

if __FILE__ == $0
  puts "Enter Player 1's name (white)"
  player1 = gets.chomp
  puts "Enter Player 2's name (black)"
  player2 = gets.chomp
  g = Game.new(player1,player2)
  g.play
end
