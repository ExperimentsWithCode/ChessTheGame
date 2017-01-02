require 'singleton'
require 'colorize'

class Piece

  attr_reader :color
  def initialize(color_flag)
    @color = color_flag ? :white : :black
  end

  def to_s
    if self.class == King || self.class == Queen
      self.class.to_s.upcase[0]
    else
      self.class.to_s.downcase[0]
    end
  end

end

class NullPiece < Piece
  include Singleton
  def initialize
  end
end

class Pawn < Piece
end

class Rook < Piece
end

class Knight < Piece
end

class Bishop < Piece
end

class Queen < Piece
end

class King < Piece
end
