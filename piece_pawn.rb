require_relative 'piece.rb'
require 'byebug'


class Pawn < Piece

  def moves
    potential_moves = []
    potential_moves.concat(start_step)
    potential_moves.concat(standard_step)
    attack_step.each { |move| potential_moves.concat(move)}
    potential_moves
  end

  private

  def start_step
    if current_pos[0] == 1 || current_pos[0] == 6
      shift = color == :white ? 2 : -2
      in_between = color == :white ? 1 : -1
      new_pos = [current_pos[0] + shift, current_pos[1]]
      #debugger
      return [] unless board.in_bounds?(new_pos)
      in_between_pos = [current_pos[0] + in_between, current_pos[1]]
      if board[new_pos].is_a?(NullPiece) && board[in_between_pos].is_a?(NullPiece)
        return [new_pos]
      end
    end
    []
  end

  def standard_step
    shift = color == :white ? 1 : -1
    new_pos = [current_pos[0] + shift, current_pos[1]]
    return [] unless board.in_bounds?(new_pos)
    return [new_pos] if board[new_pos].is_a? NullPiece
    []
  end

  def attack_step
    possible_positions = []
    attack_deltas = [[1,1],[1,-1]]
    shift = color == :white ? 1 : -1
    attack_deltas.each do |delta|
      new_pos = [current_pos[0] + delta[0] * shift, current_pos[1] + delta[1] ]
      if board.in_bounds?(new_pos)
        unless board[new_pos].is_a? NullPiece
          possible_positions << [new_pos] unless board[new_pos].color == color
        end
      end
    end
    possible_positions
  end

end













# stop here
