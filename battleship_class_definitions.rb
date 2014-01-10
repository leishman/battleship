require_relative 'battleship_utils.rb'

class PlayerBoard
  attr_accessor :board, :fleet

  def initialize(fleet)
    @fleet = fleet
    @board = []
  end

  def display
    display_board(@board)
  end


  def generate_board(message)
    10.times do
      @board << ["-","-","-","-","-","-","-","-","-","-"]
    end
    name_key = {5 => "A", 4=> "B", 3=> "C", 2=> "D", 1=> "S"}
    @fleet.ships.each do |ship|
      letter = name_key[ship.length].split[0]
      if ship.position != (nil || "")
        board[row(ship.position) - 1][column(ship.position) - 1] = letter
        if ship.heading == "h"
          1.upto(ship.length - 1) do |i|
            board[row(ship.position) - 1][column(ship.position) - 1+ i] = letter
          end
        elsif ship.heading == "v"
          1.upto(ship.length - 1) do |i|
            board[row(ship.position) - 1 + i][column(ship.position) - 1] = letter
          end
        end
      end

    end
    @board = board
    display_board(board, message)
  end

  def update(coord_of_hit)
    # p coord_of_hit
    @board[row(coord_of_hit) - 1][column(coord_of_hit) - 1] = "X"
    display_board(@board)
  end

end

class PlayerScreen

  def initialize(enemy_board)
    @enemy_board = enemy_board
    @board = []
    @hits = []
    @misses = []
  end

  def display
    display_board(@board)
  end

  def shoot(coords)
    conv_coords = "#{column(coords)}#{row(coords)}"
    # p conv_coords
    @enemy_board.fleet.ships.each do |ship|
      # p ship.combined_coords
      if ship.combined_coords.include?(conv_coords)
        p "You got hit!"
        ship.hits += 1
        @hits << conv_coords
        @enemy_board.update(coords)
        if ship.hits == ship.length
          p "You sunk a ship!"
        end
        self.update(true, coords)
      else
        self.update(false, coords)
      end
    end
  end

  def generate
    10.times do
      @board << Array.new(10,"-")
    end
  end

  def update(hit, coords)
    if hit
      letter = "X"
    else
      letter = "O"
    end
     @board[row(coords) - 1][column(coords) - 1] = letter
  end
end

class Ship
  attr_accessor :position, :heading, :length, :hits
  attr_reader :x_coords, :y_coords, :combined_coords
  def initialize(length, position = "", heading = "")
    @length = length
    @position = position
    @heading = heading
    @combined_coords = []
    @hits = 0
  end

  # Generate ship coordinates
  def gen_coordinates
      @x_coords = []
      @y_coords = []
      @combined_coords = []
    if @heading == "h"
      0.upto(@length - 1) do |i|
        @x_coords << column(@position) + i
        @y_coords << row(@position)
      end
    else
      0.upto(@length - 1) do |i|
        @x_coords << column(@position)
        @y_coords << row(@position) + i
      end
    end
    @x_coords.each_with_index do |x, i|
      @combined_coords[i] = "#{x}#{@y_coords[i]}"
    end
  end

  # Check to see if ship is in valid board position
  def check_position
    boundary = 11 - @length
    if ((@heading == "h" && column(@position) > boundary) || (@heading == "v" && row(@position) > boundary)) || (column(@position) > 10 || row(@position) > 10)
      false
    else
      true
    end
  end

end

class Fleet
  attr_accessor :aircraft_carrier, :battleship, :cruiser, :destroyer_1, :destroyer_2, :submarine_1, :submarine_2
  attr_reader :filled_coords, :ships
  def initialize
    @aircraft_carrier = Ship.new(5)
    @battleship = Ship.new(4)
    @cruiser = Ship.new(3)
    @destroyer_1 = Ship.new(2)
    @destroyer_2 = Ship.new(2)
    @submarine_1 = Ship.new(1)
    @submarine_2 = Ship.new(1)
    @ships = [@aircraft_carrier, @battleship, @cruiser, @destroyer_1, @destroyer_2, @submarine_1, @submarine_2]
    @filled_coords = []
  end

  def add_to_fleet_coords(ship)
    ship.gen_coordinates
    @filled_coords.concat(ship.combined_coords)
  end

  # Returns false if there is collision detected
  def check_coords(ship)
    if !(ship.combined_coords & @filled_coords).empty?
      false
    else
      true
    end
  end
end