class Player
attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def play_turn
    puts "#{name}, make a move you so and so"
    sleep(1)
  end

end
