require 'singleton'

class Piece
  def initialize(color_flag)
    @color = color_flag ? :white : :black
  end


end

class NullPiece < Piece
  include Singleton
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
